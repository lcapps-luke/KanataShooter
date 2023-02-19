package enemy;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;

class Enemy extends FlxSprite {
	public var killCallback:Enemy->Void;
	public var group:FlxTypedGroup<Enemy>;

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (x < -width) {
			exists = false;
		}

		if (y < 0) {
			y = 0;
			this.velocity.y = Math.abs(this.velocity.y);
		}

		if (y > FlxG.height - height) {
			y = FlxG.height - height;
			this.velocity.y = -Math.abs(this.velocity.y);
		}
	}

	override function kill() {
		super.kill();

		if (killCallback != null) {
			killCallback(this);
		}
	}

	private function makeEnemy(offsetX:Float, offsetY:Float) {
		var a = group.recycle(SingleEnemy, SingleEnemy.new);
		a.group = group;
		a.killCallback = killCallback;
		a.drag.set(0, 100);
		a.velocity.copyFrom(velocity);

		var p = FlxPoint.get(offsetX, offsetY).rotateByDegrees(this.angle);
		a.x = x + p.x;
		a.y = y + p.y;
		FlxDestroyUtil.put(p);

		return a;
	}
}
