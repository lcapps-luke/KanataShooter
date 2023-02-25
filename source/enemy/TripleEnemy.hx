package enemy;

import flixel.FlxG;

class TripleEnemy extends Enemy {
	public function new() {
		super(0, 0, AssetPaths.enemy_3__png);
		health = 6;
		angle = FlxG.random.float(0, 360);

		this.size = 3;
	}

	override function revive() {
		super.revive();
		health = 3;
		angle = FlxG.random.float(0, 360);
	}

	override function kill() {
		super.kill();

		var children = new Array<Enemy>();

		children.push(makeEnemy(-2, -54));
		children.push(makeEnemy(-48, 45));
		children.push(makeEnemy(47, 13));

		children.sort((a, b) -> Math.round(a.y - b.y));

		children[0].velocity.add(0, -200);
		children[2].velocity.add(0, 200);
	}
}
