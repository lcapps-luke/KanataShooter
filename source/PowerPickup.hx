package;

import flixel.FlxG;
import flixel.FlxSprite;

class PowerPickup extends FlxSprite {
	private var attractDir:Null<Float> = null;

	public function new() {
		super(0, 0, AssetPaths.feather__png);
	}

	public function emit(x:Float, y:Float, xSpeed:Float) {
		this.x = x;
		this.y = y;

		var dir = FlxG.random.float(0, Math.PI * 2);
		var spd = FlxG.random.float(100, 200);

		this.velocity.set(Math.cos(dir) * spd, Math.sin(dir) * spd);

		this.maxVelocity.set(Math.abs(xSpeed), 10000);
		this.acceleration.set(-100, 0);
		this.drag.set(100, 100);

		this.angle = FlxG.random.float(0, 360);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (x < -width) {
			kill();
		}

		if (y > FlxG.height - height) {
			y = FlxG.height - height;
		}

		if (y < 0) {
			y = 0;
		}

		if (attractDir != null) {
			x += Math.cos(attractDir) * 500 * elapsed;
			y += Math.sin(attractDir) * 500 * elapsed;

			attractDir = null;
		}
	}

	public function attractTo(target:FlxSprite) {
		attractDir = Math.atan2((target.y + target.height / 2) - (y + height / 2), (target.x + target.width / 2) - (x + width / 2));
	}
}
