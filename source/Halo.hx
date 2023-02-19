package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColorTransformUtil;

class Halo extends FlxSprite {
	public function new() {
		super();

		loadGraphic(AssetPaths.halo__png, true, 50, 50);
		animation.add("spin", [0, 1, 2, 3, 4], 24, true);
		animation.play("spin");

		FlxColorTransformUtil.setOffsets(colorTransform, 200, 124, -200, 0);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (x > FlxG.width + width) {
			kill();
		}
	}
}
