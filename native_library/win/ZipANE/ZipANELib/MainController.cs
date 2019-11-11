using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using TuaRua.FreSharp;
using TuaRua.FreSharp.Exceptions;
using FREObject = System.IntPtr;
using FREContext = System.IntPtr;
using System.IO.Compression;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

// ReSharper disable UnusedMember.Global

namespace ZipLib {
    public class MainController : FreSharpMainController {
        public string[] GetFunctions() {
            FunctionsDict =
                new Dictionary<string, Func<FREObject, uint, FREObject[], FREObject>> {
                    {"init", InitController},
                    {"compress", Compress},
                    {"extract", Extract},
                    {"extractEntry", ExtractEntry}
                };
            return FunctionsDict.Select(kvp => kvp.Key).ToArray();
        }

        private FREObject Compress(FREContext ctx, uint argc, FREObject[] argv) {
            if (argc < 2) return new FreArgException().RawValue;
            if (argv[0] == FREObject.Zero) return new FreArgException().RawValue;
            if (argv[1] == FREObject.Zero) return new FreArgException().RawValue;
            try {
                var path = argv[0].AsString();
                var directory = argv[1].AsString();

                var task = CompressAsync(path, directory);
                task.ContinueWith(previous => {
                    if (previous.Status == TaskStatus.RanToCompletion) {
                        DispatchEvent(CompressEvent.OnComplete, GetZipEventJson(path));
                    }
                    else {
                        DispatchEvent(ZipErrorEvent.OnError, GetZipErrorEventJson(path, previous.Exception?.Message));
                    }
                }, TaskContinuationOptions.ExecuteSynchronously);
            }
            catch (Exception e) {
                return new FreException(e).RawValue;
            }

            return FREObject.Zero;
        }


        private FREObject Extract(FREContext ctx, uint argc, FREObject[] argv) {
            if (argc < 2) return new FreArgException().RawValue;
            if (argv[0] == FREObject.Zero) return new FreArgException().RawValue;
            if (argv[1] == FREObject.Zero) return new FreArgException().RawValue;
            try {
                var path = argv[0].AsString();
                var directory = argv[1].AsString();
                var task = ExtractAsync(path, directory);
                task.ContinueWith(previous => {
                    if (previous.Status == TaskStatus.RanToCompletion) {
                        DispatchEvent(ExtractEvent.OnComplete, GetZipEventJson(path));
                    }
                    else {
                        DispatchEvent(ZipErrorEvent.OnError, GetZipErrorEventJson(path, previous.Exception?.Message));
                    }
                }, TaskContinuationOptions.ExecuteSynchronously);
            }
            catch (Exception e) {
                return new FreException(e).RawValue;
            }

            return FREObject.Zero;
        }

        private FREObject ExtractEntry(FREContext ctx, uint argc, FREObject[] argv) {
            if (argc < 3) return new FreArgException().RawValue;
            if (argv[0] == FREObject.Zero) return new FreArgException().RawValue;
            if (argv[1] == FREObject.Zero) return new FreArgException().RawValue;
            if (argv[2] == FREObject.Zero) return new FreArgException().RawValue;
            try {
                var path = argv[0].AsString();
                var entryPath = argv[1].AsString();
                var directory = argv[2].AsString();
                var task = ExtractAsync(path, directory, entryPath);
                task.ContinueWith(previous => {
                    if (previous.Status == TaskStatus.RanToCompletion) {
                        DispatchEvent(ExtractEvent.OnComplete, GetZipEventJson(path));
                    }
                    else {
                        DispatchEvent(ZipErrorEvent.OnError, GetZipErrorEventJson(path, previous.Exception?.Message));
                    }
                }, TaskContinuationOptions.ExecuteSynchronously);
            }
            catch (Exception e) {
                return new FreException(e).RawValue;
            }

            return FREObject.Zero;
        }

        private async Task<bool> ExtractAsync(string path, string directory, string entryPath = null) {
            await Task.Run(() => {
                var bytesTotal = UncompressedSize(path);
                using (var archive = ZipFile.OpenRead(path)) {
                    var bytes = 0L;
                    foreach (var entry in archive.Entries) {
                        if (!string.IsNullOrEmpty(entryPath)) {
                            entryPath = entryPath.Replace("/", "\\");
                            if (entryPath == entry.FullName) {
                                bytesTotal = entry.Length;
                            }
                            else {
                                continue;
                            }
                        }

                        DispatchEvent(ExtractProgressEvent.Progress,
                            GetProgressEventJson(path, bytes, bytesTotal, entry.FullName));
                        bytes += entry.Length;
                        var fullPath = Path.Combine(directory, entry.FullName);
                        var fileFolder = Path.GetDirectoryName(fullPath);
                        if (fileFolder != null && !File.Exists(fileFolder)) {
                            Directory.CreateDirectory(fileFolder);
                        }

                        entry.ExtractToFile(fullPath, true);
                        if (!string.IsNullOrEmpty(entryPath) && entryPath == entry.FullName) {
                            break;
                        }
                    }

                    DispatchEvent(ExtractProgressEvent.Progress, GetProgressEventJson(path, bytesTotal, bytesTotal));
                }
            });
            return true;
        }

        private async Task<bool> CompressAsync(string path, string directory) {
            await Task.Run(() => {
                var sourceFiles = new DirectoryInfo(directory).GetFiles("*", SearchOption.AllDirectories);
                var bytesTotal = sourceFiles.Sum(f => f.Length);
                using (var zipToOpen = new FileStream(path, FileMode.Create)) {
                    using (var archive = new ZipArchive(zipToOpen, ZipArchiveMode.Update)) {
                        var bytes = 0L;
                        foreach (var file in sourceFiles) {
                            DispatchEvent(CompressProgressEvent.Progress,
                                GetProgressEventJson(path, bytes, bytesTotal,
                                    file.FullName.Substring(directory.Length + 1)));
                            bytes += file.Length;

                            var entryName = file.FullName.Substring(directory.Length + 1);
                            var entry = archive.CreateEntry(entryName);

                            using (var writer = new BinaryWriter(entry.Open())) {
                                var buffer = File.ReadAllBytes(file.FullName);
                                writer.Write(buffer);
                                writer.Flush();
                                writer.Close();
                            }
                        }
                    }
                }

                DispatchEvent(CompressProgressEvent.Progress, GetProgressEventJson(path, bytesTotal, bytesTotal));
            });
            return true;
        }

        private static string GetZipEventJson(string path) {
            var json = JObject.FromObject(new {
                path
            });
            return json.ToString();
        }

        private static string GetZipErrorEventJson(string path, string message) {
            var json = JObject.FromObject(new {
                path,
                message = string.IsNullOrEmpty(message) ? "" : message
            });
            return json.ToString();
        }

        private static string GetProgressEventJson(string path, long bytes, long bytesTotal, string nextEntry = "") {
            var json = JObject.FromObject(new {
                path,
                bytes,
                bytesTotal,
                nextEntry
            });
            return json.ToString();
        }

        private static long UncompressedSize(string path) {
            var totalSize = 0L;
            using (var archive = ZipFile.OpenRead(path)) {
                totalSize += archive.Entries.Sum(entry => entry.Length);
            }

            return totalSize;
        }

        private FREObject InitController(FREContext ctx, uint argc, FREObject[] argv) {
            FreSharpLogger.GetInstance().Context = Context;
            return true.ToFREObject();
        }

        public override void OnFinalize() { }

        public override string TAG => "MainController";
    }
}