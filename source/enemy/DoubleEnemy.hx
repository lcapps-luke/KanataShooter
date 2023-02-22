package enemy;

import flixel.FlxG;

class DoubleEnemy extends Enemy {
	public function new() {
		super(0, 0, AssetPaths.enemy_2__png);
		health = 3;
		angle = FlxG.random.float(0, 360);

		this.size = 2;
	}

	override function revive() {
		super.revive();
		health = 3;
		angle = FlxG.random.float(0, 360);
	}

	override function kill() {
		super.kill();

		var a = makeEnemy(0, -30);
		a.velocity.add(0, a.y > y ? 200 : -200);

		a = makeEnemy(0, 30);
		a.velocity.add(0, a.y > y ? 200 : -200);
	}
}
