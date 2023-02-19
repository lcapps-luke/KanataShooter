package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColorTransformUtil;

class Cloud extends FlxSprite {
	private static var CLOUD_SPR = [
		AssetPaths.cloud_1__png,
		AssetPaths.cloud_2__png,
		AssetPaths.cloud_3__png,
		AssetPaths.cloud_4__png,
		AssetPaths.cloud_5__png,
		AssetPaths.cloud_6__png,
		AssetPaths.cloud_7__png,
		AssetPaths.cloud_8__png,
		AssetPaths.cloud_9__png
	];

	public function new() {
		var i = FlxG.random.int(0, 8);
		var spr = CLOUD_SPR[i];

		super(0, 0, spr);
		this.solid = false;

		FlxColorTransformUtil.setOffsets(colorTransform, FlxG.random.int(-39, 0), FlxG.random.int(19, 57), FlxG.random.int(56, 92), 0);
	}

	override function revive() {
		super.revive();
		FlxColorTransformUtil.setOffsets(colorTransform, FlxG.random.int(-39, 0), FlxG.random.int(19, 57), FlxG.random.int(56, 92), 0);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (x + width < 0) {
			x = FlxG.width * 2;
		}
	}
}
