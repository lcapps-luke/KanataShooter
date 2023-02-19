package enemy;

import flixel.FlxG;

class QuadEnemy extends Enemy {
	public function new() {
		super(0, 0, AssetPaths.enemy_4__png);
		health = 3;
		angle = FlxG.random.float(0, 360);
	}

	override function revive() {
		super.revive();
		health = 3;
		angle = FlxG.random.float(0, 360);
	}

	override function kill() {
		super.kill();

		var children = new Array<Enemy>();

		children.push(makeEnemy(-59, -48));
		children.push(makeEnemy(56, -24));
		children.push(makeEnemy(-43, 35));
		children.push(makeEnemy(44, 44));

		children.sort((a, b) -> Math.round(a.y - b.y));

		children[0].velocity.add(0, -200);
		children[1].velocity.add(0, -100);
		children[2].velocity.add(0, 100);
		children[3].velocity.add(0, 200);
	}
}
