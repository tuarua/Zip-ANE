package {
import com.tuarua.CommonDependencies;
import com.tuarua.ZipANE;
import com.tuarua.zipane.ZipFile;
import com.tuarua.zipane.events.CompressEvent;
import com.tuarua.zipane.events.CompressProgressEvent;
import com.tuarua.zipane.events.ExtractEvent;
import com.tuarua.zipane.events.ExtractProgressEvent;

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
    private var commonDependenciesANE:CommonDependencies = new CommonDependencies(); //must create before all others
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
        btnZip.addEventListener(TouchEvent.TOUCH, onZipClick);
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

    private function onZipClick(event:TouchEvent):void {
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
    }

    private static function copyEmbedFiles():void {
        var inFile1:File = File.applicationDirectory.resolvePath("zipme.zip");
        var outFile1:File = File.applicationStorageDirectory.resolvePath("zipme.zip");
        inFile1.copyTo(outFile1, true);

        trace(File.applicationStorageDirectory.resolvePath("zipme").nativePath);

        var inFile2:File = File.applicationDirectory.resolvePath("zipme");
        var outFile2:File = File.applicationStorageDirectory.resolvePath("zipme");
        inFile2.copyTo(outFile2, true);
    }

    private function onExiting(event:Event):void {
        ZipANE.dispose();
        commonDependenciesANE.dispose();
    }

}
}