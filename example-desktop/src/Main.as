package {
import com.tuarua.FreSharp;
import com.tuarua.FreSwift;
import com.tuarua.Zip;
import com.tuarua.zip.ZipFile;
import com.tuarua.zip.events.CompressEvent;
import com.tuarua.zip.events.CompressProgressEvent;
import com.tuarua.zip.events.ExtractEvent;
import com.tuarua.zip.events.ExtractProgressEvent;

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.text.AntiAliasType;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;

import views.SimpleButton;

[SWF(width="800", height="600", frameRate="60", backgroundColor="#FFFFFF")]
public class Main extends Sprite {
    private var freSharpANE:FreSharp = new FreSharp(); // must create before all others
    private var freSwiftANE:FreSwift = new FreSwift(); // must create before all others
    public static const FONT:Font = new FiraSansSemiBold();
    private var btnZip:SimpleButton = new SimpleButton("Zip Files");
    private var btnExtract:SimpleButton = new SimpleButton("Extract Zip");
    private var statusLabel:TextField = new TextField();

    public function Main() {
        super();
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        start();

        NativeApplication.nativeApplication.executeInBackground = true;
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);

    }

    public function start():void {
        initMenu();
        copyEmbedFiles();
    }

    private function initMenu():void {
        btnExtract.x = btnZip.x = (stage.stageWidth - 200) * 0.5;
        btnZip.y = 100;
        btnZip.addEventListener(MouseEvent.CLICK, onZipClick);
        addChild(btnZip);

        btnExtract.y = 180;
        btnExtract.addEventListener(MouseEvent.CLICK, onExtractClick);

        addChild(btnExtract);

        var tf:TextFormat = new TextFormat(Main.FONT.fontName, 13, 0x222222);
        tf.align = "center";

        statusLabel.defaultTextFormat = tf;
        statusLabel.width = stage.stageWidth;
        statusLabel.y = btnExtract.y + 75;

        statusLabel.wordWrap = statusLabel.multiline = false;
        statusLabel.selectable = false;
        statusLabel.embedFonts = true;
        statusLabel.antiAliasType = AntiAliasType.ADVANCED;
        statusLabel.sharpness = -100;

        addChild(statusLabel);

    }

    private function onExtractClick(event:MouseEvent):void {
        var zipFile:ZipFile = new ZipFile(File.applicationStorageDirectory.resolvePath("zipme.zip"));
        zipFile.addEventListener(ExtractProgressEvent.PROGRESS, onExtractProgress);
        zipFile.addEventListener(ExtractEvent.COMPLETE, onExtractComplete);
        if (zipFile.exists) {
            if (!File.applicationStorageDirectory.resolvePath("extract").exists) {
                File.applicationStorageDirectory.resolvePath("extract").createDirectory();
            }
            // zipFile.extractEntry("images\\adobe-air-logo.png", File.applicationStorageDirectory.resolvePath("extract"));
            zipFile.extract(File.applicationStorageDirectory.resolvePath("extract"));
        }
    }

    private function onZipClick(event:MouseEvent):void {
        var zipFile:ZipFile = new ZipFile(File.applicationStorageDirectory.resolvePath("zipme_created.zip"));
        zipFile.addEventListener(CompressProgressEvent.PROGRESS, onCompressProgress);
        zipFile.addEventListener(CompressEvent.COMPLETE, onCompressComplete);
        var zipSource:File = File.applicationStorageDirectory.resolvePath("zipme");
        zipFile.compress(zipSource);
    }

    private function onExtractProgress(event:ExtractProgressEvent):void {
        trace(event);
        statusLabel.text = Math.floor((event.bytes / event.bytesTotal) * 100) + "% extracted";
    }

    private function onCompressProgress(event:CompressProgressEvent):void {
        trace(event);
        statusLabel.text = Math.floor((event.bytes / event.bytesTotal) * 100) + "% compressed";
    }

    private function onCompressComplete(event:CompressEvent):void {
        trace(event);
        statusLabel.text = "compression complete";
    }

    private function onExtractComplete(event:ExtractEvent):void {
        trace(event);
        statusLabel.text = "extraction complete";
    }

    private static function copyEmbedFiles():void {
        var inFile1:File = File.applicationDirectory.resolvePath("zipme.zip");
        var outFile1:File = File.applicationStorageDirectory.resolvePath("zipme.zip");
        trace(inFile1.nativePath);
        trace("inFile1.exists", inFile1.exists);
        if (inFile1.exists) {
            inFile1.copyTo(outFile1, true);
        }

        trace(File.applicationStorageDirectory.resolvePath("zipme").nativePath);

        var inFile2:File = File.applicationDirectory.resolvePath("zipme");
        var outFile2:File = File.applicationStorageDirectory.resolvePath("zipme");
        if (inFile2.exists) {
            inFile2.copyTo(outFile2, true);
        }

    }

    private function onExiting(event:Event):void {
        Zip.dispose();
        FreSwift.dispose();
        FreSharp.dispose();
    }

}
}