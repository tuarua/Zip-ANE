package {
import com.tuarua.Zip;
import com.tuarua.zip.ZipFile;
import com.tuarua.zip.events.CompressEvent;
import com.tuarua.zip.events.CompressProgressEvent;
import com.tuarua.zip.events.ExtractEvent;
import com.tuarua.zip.events.ExtractProgressEvent;

import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.filesystem.File;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class StarlingRoot extends Sprite {
    private var btnZip:SimpleButton = new SimpleButton("Zip Files");
    private var btnExtract:SimpleButton = new SimpleButton("Extract Zip");
    private var btnInfo:SimpleButton = new SimpleButton("Get Info");

    private var statusLabel:TextField;

    public function StarlingRoot() {
        TextField.registerCompositor(Fonts.getFont("fira-sans-semi-bold-13"), "Fira Sans Semi-Bold 13");
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
    }

    public function start():void {
        initMenu();
        copyEmbedFiles();
    }

    private function initMenu():void {
        btnInfo.x = btnExtract.x = btnZip.x = (stage.stageWidth - 200) * 0.5;
        btnZip.y = 100;
        btnZip.addEventListener(TouchEvent.TOUCH, onCompressClick);
        addChild(btnZip);

        btnExtract.y = 180;
        btnExtract.addEventListener(TouchEvent.TOUCH, onExtractClick);
        addChild(btnExtract);

        btnInfo.y = 260;
        btnInfo.addEventListener(TouchEvent.TOUCH, onInfoClick);
        // addChild(btnInfo);

        statusLabel = new TextField(stage.stageWidth, 100, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnExtract.y + 75;
        addChild(statusLabel);

    }

    private function onCompressClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnZip);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var zipFile:ZipFile = new ZipFile(File.applicationStorageDirectory.resolvePath("zipme_created.zip"));
            zipFile.addEventListener(CompressProgressEvent.PROGRESS, onCompressProgress);
            zipFile.addEventListener(CompressEvent.COMPLETE, onCompressComplete);
            var zipSource:File = File.applicationStorageDirectory.resolvePath("zipme");
            zipFile.compress(zipSource);

        }
    }

    private function onExtractClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnExtract);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var zipFile:ZipFile = new ZipFile(File.applicationStorageDirectory.resolvePath("zipme.zip"));
            if (zipFile.exists) {
                zipFile.addEventListener(ExtractProgressEvent.PROGRESS, onExtractProgress);
                zipFile.addEventListener(ExtractEvent.COMPLETE, onExtractComplete);
                if (!File.applicationStorageDirectory.resolvePath("extract").exists) {
                    File.applicationStorageDirectory.resolvePath("extract").createDirectory();
                }
                // zipFile.extractEntry("images\\adobe-air-logo.png", File.applicationStorageDirectory.resolvePath("extract"));
                zipFile.extract(File.applicationStorageDirectory.resolvePath("extract"));
            }
        }
    }

    private function onInfoClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnInfo);
        if (touch != null && touch.phase == TouchPhase.ENDED) {

        }
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

        var file:File = File.applicationStorageDirectory.resolvePath("extract/images/adobe-air-logo.png"); ///images/adobe-air-logo.png
        trace("does image exist", file.exists);
    }

    private static function copyEmbedFiles():void {
        var inFile1:File = File.applicationDirectory.resolvePath("zipme.zip");
        var outFile1:File = File.applicationStorageDirectory.resolvePath("zipme.zip");
        inFile1.copyTo(outFile1, true);

        var inFile2:File = File.applicationDirectory.resolvePath("zipme");
        var outFile2:File = File.applicationStorageDirectory.resolvePath("zipme");
        inFile2.copyTo(outFile2, true);
    }

    private function onExiting(event:Event):void {
        Zip.dispose();
    }

}
}