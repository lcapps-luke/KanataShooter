package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColorTransformUtil;

class Halo extends FlxSprite {
	private var initialY:Float;
	private var motionFunction:Float->Float = null;
	private var motionFunctionTime:Float = 0;
	private var motionFunctionTimeIncrement:Float = 0;

	public function new() {
		super();

		loadGraphic(AssetPaths.halo__png, true, 50, 50);
		animation.add("spin", [0, 1, 2, 3, 4], 24, true);
		animation.play("spin");

		FlxColorTransformUtil.setOffsets(colorTransform, 200, 124, -200, 0);
	}

	override function revive() {
		super.revive();

		motionFunction = null;
		motionFunctionTime = 0;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (x > FlxG.width + width) {
			kill();
		}

		if (motionFunction != null) {
			motionFunctionTime += motionFunctionTimeIncrement * elapsed;
			this.y = initialY + motionFunction(motionFunctionTime);
		}
	}

	public function setMotionFunction(func:Float->Float, increment:Float) {
		this.motionFunction = func;
		this.motionFunctionTimeIncrement = increment;
		initialY = y;
	}
}
