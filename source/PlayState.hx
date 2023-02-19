package;

import enemy.DoubleEnemy;
import enemy.Enemy;
import enemy.QuadEnemy;
import enemy.SingleEnemy;
import enemy.TrippleEnemy;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionManager;
import flixel.text.FlxText;
import flixel.util.FlxGradient;

class PlayState extends FlxState {
	private static inline var SPEED = 512.0;
	private static inline var SHOOT_COOLDOWN = 0.25;
	private static inline var HALO_SPEED = 1280;

	private static var ACTIONS:FlxActionManager;

	private var starBg:Array<FlxSprite> = [];
	private var cloudBack:FlxTypedGroup<Cloud>;
	private var enemyParticles:FlxEmitter;
	private var kanata:FlxSprite;
	private var enemy:FlxTypedGroup<Enemy>;
	private var playerBullet:FlxTypedSpriteGroup<Halo>;
	private var cloudFront:FlxTypedGroup<Cloud>;
	private var scoreText:FlxText;

	private var up:FlxActionDigital;
	private var down:FlxActionDigital;
	private var left:FlxActionDigital;
	private var right:FlxActionDigital;
	private var shoot:FlxActionDigital;

	private var shootCooldown:Float = 0;
	private var score:Int = 0;

	private var enemySpawnTimer:Float = 0;

	override public function create() {
		super.create();

		var bg = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [0xFF7E09DC, 0xFF1C6ED5]);
		bg.solid = false;
		add(bg);

		makeStarLayer(-30);
		makeStarLayer(-15, true);

		cloudBack = makeCloudLayer(0.4, 0.8, -50);

		enemyParticles = new FlxEmitter();
		enemyParticles.loadParticles(AssetPaths.enemy_particle__png, 200, 0);
		enemyParticles.launchMode = CIRCLE;
		enemyParticles.scale.set(1, 1, 1.5, 1.5, 0, 0, 0, 0);
		enemyParticles.speed.set(100, 300);
		enemyParticles.lifespan.set(0.25, 0.75);
		add(enemyParticles);

		playerBullet = new FlxTypedSpriteGroup<Halo>();
		add(playerBullet);

		kanata = new Kanata(playerBullet);
		kanata.x = FlxG.width * 0.25;
		kanata.y = FlxG.height * 0.5;
		add(kanata);

		enemy = new FlxTypedGroup<Enemy>();
		add(enemy);

		cloudFront = makeCloudLayer(0.2, 0.5, -70);

		scoreText = new FlxText(40, 40);
		scoreText.size = 72;
		add(scoreText);
	}

	private inline function makeStarLayer(speed:Int, flip:Bool = false) {
		var a = new FlxSprite(0, 0, AssetPaths.stars__png);
		a.velocity.set(speed);
		a.solid = false;
		add(a);
		starBg.push(a);

		var b = new FlxSprite(a.width, 0, AssetPaths.stars__png);
		b.velocity.set(speed);
		add(b);
		starBg.push(b);

		if (flip) {
			a.flipX = true;
			a.flipY = true;
			b.flipX = true;
			b.flipY = true;
		}
	}

	private inline function makeCloudLayer(minHeight:Float, maxHeight:Float, speed:Float):FlxTypedGroup<Cloud> {
		var cloud = new FlxTypedGroup<Cloud>();
		add(cloud);
		var cSep = (FlxG.width * 2) / 10;
		for (i in 0...11) {
			var c = cloud.recycle(Cloud, Cloud.new);
			c.x = FlxG.random.float(cSep * i - 150, cSep * i + 150);
			c.y = FlxG.height - FlxG.random.float(c.height * minHeight, c.height * maxHeight);
			c.velocity.set(speed);
		}
		return cloud;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		scoreText.text = Std.string(score);

		// bullet-enemy collision
		FlxG.overlap(playerBullet, enemy, onBulletEnemyOverlap, onBulletEnemyCheck);

		// enemy-player collision
		FlxG.overlap(kanata, enemy, onPlayerHit);

		for (s in starBg) {
			if (s.x < -s.width) {
				s.x = s.width;
			}
		}

		enemySpawnTimer -= elapsed;
		if (enemySpawnTimer < 0) {
			var e = getNextEnemy(score);
			e.y = FlxG.random.float(0, FlxG.height - e.height);
			e.x = FlxG.width;
			e.velocity.set(-200);
			e.killCallback = onEnemyKill;
			e.group = enemy;

			var minTime = Math.abs(e.velocity.x / e.width);
			enemySpawnTimer = FlxG.random.float(minTime, minTime * 2);
		}
	}

	private function onBulletEnemyCheck(halo:Halo, enemy:Enemy) {
		return FlxG.pixelPerfectOverlap(halo, enemy);
	}

	private function onBulletEnemyOverlap(halo:Halo, enemy:Enemy) {
		halo.kill();
		enemy.hurt(1);
	}

	private function onPlayerHit(player:Kanata, enemy:Enemy) {
		enemy.kill();
		kanata.hurt(0);
		score = 0;
	}

	private function onEnemyKill(enemy:Enemy) {
		score++;

		enemyParticles.x = enemy.x;
		enemyParticles.y = enemy.y;
		enemyParticles.width = enemy.width;
		enemyParticles.height = enemy.height;
		enemyParticles.start(true, 1, 40);
	}

	function getNextEnemy(score:Int):Enemy {
		// 1
		if (score < 5) {
			return enemy.recycle(SingleEnemy, SingleEnemy.new);
		}

		// int 2
		if (score < 30) {
			return FlxG.random.bool(25) ? enemy.recycle(DoubleEnemy, DoubleEnemy.new) : enemy.recycle(SingleEnemy, SingleEnemy.new);
		}

		// 2
		if (score < 60) {
			return FlxG.random.bool(50) ? enemy.recycle(DoubleEnemy, DoubleEnemy.new) : enemy.recycle(SingleEnemy, SingleEnemy.new);
		}

		// int 3
		if (score < 100) {
			if (FlxG.random.bool(25)) {
				return enemy.recycle(TrippleEnemy, TrippleEnemy.new);
			}
			else {
				return FlxG.random.bool(50) ? enemy.recycle(DoubleEnemy, DoubleEnemy.new) : enemy.recycle(SingleEnemy, SingleEnemy.new);
			}
		}

		// 3
		if (score < 150) {
			switch (FlxG.random.int(0, 2)) {
				case 0:
					return enemy.recycle(SingleEnemy, SingleEnemy.new);
				case 1:
					return enemy.recycle(DoubleEnemy, DoubleEnemy.new);
				default:
					return enemy.recycle(TrippleEnemy, TrippleEnemy.new);
			}
		}

		// int 4
		if (score < 220) {
			if (FlxG.random.bool(25)) {
				return enemy.recycle(QuadEnemy, QuadEnemy.new);
			}
			else {
				switch (FlxG.random.int(0, 2)) {
					case 0:
						return enemy.recycle(SingleEnemy, SingleEnemy.new);
					case 1:
						return enemy.recycle(DoubleEnemy, DoubleEnemy.new);
					default:
						return enemy.recycle(TrippleEnemy, TrippleEnemy.new);
				}
			}
		}

		// 4
		if (score < 300) {
			switch (FlxG.random.int(0, 3)) {
				case 0:
					return enemy.recycle(SingleEnemy, SingleEnemy.new);
				case 1:
					return enemy.recycle(DoubleEnemy, DoubleEnemy.new);
				case 2:
					return enemy.recycle(TrippleEnemy, TrippleEnemy.new);
				default:
					return enemy.recycle(QuadEnemy, QuadEnemy.new);
			}
		}

		if (score < 400) {
			switch (FlxG.random.int(0, 2)) {
				case 0:
					return enemy.recycle(DoubleEnemy, DoubleEnemy.new);
				case 1:
					return enemy.recycle(TrippleEnemy, TrippleEnemy.new);
				default:
					return enemy.recycle(QuadEnemy, QuadEnemy.new);
			}
		}

		if (score < 500) {
			return FlxG.random.bool(50) ? enemy.recycle(TrippleEnemy, TrippleEnemy.new) : enemy.recycle(QuadEnemy, QuadEnemy.new);
		}

		return enemy.recycle(QuadEnemy, QuadEnemy.new);
	}
}
