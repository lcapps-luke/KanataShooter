package enemy;

class SingleEnemy extends Enemy {
	public function new() {
		super(0, 0, AssetPaths.enemy_1__png);
		health = 2;
	}

	override function revive() {
		super.revive();
		health = 2;
	}
}
