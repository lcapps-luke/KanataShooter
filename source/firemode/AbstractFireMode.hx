package firemode;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

abstract class AbstractFireMode {
	private static inline var HALO_SPEED = 1280;

	private var cooldown:Float = 0;
	private var haloGroup:FlxTypedSpriteGroup<Halo>;
	private var x:Float = 0;
	private var y:Float = 0;

	public function new(haloGroup:FlxTypedSpriteGroup<Halo>) {
		this.haloGroup = haloGroup;
	}

	public function update(s:Float, x:Float, y:Float, firing:Bool) {
		this.x = x;
		this.y = y;

		if (cooldown > 0) {
			cooldown -= s;
		}
		else if (firing) {
			cooldown = fire();
		}
	}

	private function makeHalo(offsetX:Float = 0, offsetY:Float = 0) {
		var b = haloGroup.recycle(Halo, Halo.new);
		b.x = x + offsetX;
		b.y = y + offsetY;
		trace(offsetY);
		b.velocity.set(HALO_SPEED);
	}

	private abstract function fire():Float;
}
