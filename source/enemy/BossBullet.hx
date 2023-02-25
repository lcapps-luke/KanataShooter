package enemy;

class BossBullet extends Enemy {
	public function new() {
		super(0, 0, AssetPaths.boss_bullet__png);

		canKill = false;
	}

	override function reset(x:Float, y:Float) {
		super.reset(x, y);
		scale.set(0, 0);
		health = 1;
		velocity.set(-300, 0);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (scale.x < 1) {
			scale.x = Math.min(scale.x + 2 * elapsed, 1);
			scale.y = scale.x;
		}
	}
}
