package views {
import com.greensock.TweenLite;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormat;

public class SimpleButton extends flash.display.SimpleButton {
    private var highlight:Shape;
    public function SimpleButton(text:String, w:int = 200) {
        var container:Sprite = new Sprite();
        var bg:Shape = new Shape();
        bg.graphics.beginFill(0x337AB7);
        bg.graphics.drawRect(0, 0, w, 36);
        bg.graphics.endFill();

        var line:Shape = new Shape();
        line.graphics.beginFill(0x2E6BA1);
        line.graphics.drawRect(0, 36, w, 2);
        line.graphics.endFill();

        var lbl:TextField = new TextField();
        lbl.selectable = false;
        lbl.width = w;
        lbl.y = 7;

        lbl.wordWrap = lbl.multiline = false;
        lbl.selectable = false;
        lbl.embedFonts = true;
        lbl.antiAliasType = AntiAliasType.ADVANCED;
        lbl.sharpness = -100;

        var tf:TextFormat = new TextFormat(Main.FONT.fontName, 13, 0xFFFFFF);
        tf.align = "center";
        tf.bold = false;
        lbl.defaultTextFormat = tf;
        lbl.text = text;

        highlight = new Shape();
        highlight.graphics.beginFill(0xFFFFFF);
        highlight.graphics.drawRect(0, 0, w, 38);
        highlight.graphics.endFill();

        container.addChild(bg);
        container.addChild(line);
        container.addChild(lbl);
        highlight.alpha = 0;
        container.addChild(highlight);
        container.cacheAsBitmap = true;

        this.upState = container;
        this.downState = container;
        this.overState = container;
        this.hitTestState = container;
        this.useHandCursor = false;
        this.addEventListener(MouseEvent.CLICK, onClick);
    }

    private function onClick(event:MouseEvent):void {
        var highlightTween:TweenLite = TweenLite.to(highlight, 0.05, {alpha: 0.25});
        highlightTween.eventCallback("onComplete", function ():void {
            highlightTween.reverse();
        });
    }
}
}
