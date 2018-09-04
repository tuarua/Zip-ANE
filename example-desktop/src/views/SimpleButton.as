package views {
import com.greensock.TweenLite;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

public class SimpleButton extends Sprite {
    private var highlight:Shape;
    public function SimpleButton(text:String, w:int = 200) {
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

        var tf:TextFormat = new TextFormat(Main.FONT.fontName, 13, 0xFFFFFF);
        tf.align = "center";
        tf.bold = false;
        lbl.defaultTextFormat = tf;
        lbl.text = text;

        highlight = new Shape();
        highlight.graphics.beginFill(0xFFFFFF);
        highlight.graphics.drawRect(0, 0, w, 38);
        highlight.graphics.endFill();

        this.addChild(bg);
        this.addChild(line);
        this.addChild(lbl);
        highlight.alpha = 0;
        this.addChild(highlight);
        this.cacheAsBitmap = true;
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
