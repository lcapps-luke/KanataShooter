package;

import flixel.system.FlxBasePreloader;
import openfl.display.GradientType;
import openfl.display.Shape;
import openfl.geom.Matrix;
import openfl.text.TextField;
import openfl.text.TextFormat;

class Preloader extends FlxBasePreloader {
	private var background:Shape;
	private var progress:TextField;

	public function new() {
		super(0);
	}

	override function create() {
		super.create();

		background = new Shape();
		var graphics = background.graphics;
		graphics.clear();

		var fillMatrix = new Matrix();
		fillMatrix.createGradientBox(1, 1, Math.PI * 0.5);
		var scaling = Math.max(stage.stageWidth, stage.stageHeight);
		fillMatrix.scale(scaling, scaling);

		graphics.beginGradientFill(GradientType.LINEAR, [0x7E09DC, 0x1C6ED5], [1, 1], [0, 255], fillMatrix);
		graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		graphics.endFill();
		addChild(background);

		progress = new TextField();
		progress.defaultTextFormat = new TextFormat("_sans", 70, 0xFFFFFF, null, null, null, null, null, CENTER);
		progress.embedFonts = true;
		progress.selectable = false;
		progress.width = stage.stageWidth;
		progress.y = stage.stageHeight / 2 - 70 / 2;
		addChild(progress);
	}

	override function update(percent:Float) {
		super.update(percent);

		progress.text = Std.string(Math.round(percent * 100)) + "%";
	}

	override function destroy() {
		super.destroy();

		removeChild(background);
		background = null;

		removeChild(progress);
		progress = null;
	}
}
