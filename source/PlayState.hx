package;

import enemy.Enemy;
import enemy.Spawner;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionManager;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;

class PlayState extends FlxState {
	private static inline var SPEED = 512.0;
	private static inline var SHOOT_COOLDOWN = 0.25;
	private static inline var HALO_SPEED = 1280;
	private static inline var PICKUP_RADIUS = 240;

	private static var ACTIONS:FlxActionManager;

	private var starBg:Array<FlxSprite> = [];
	private var cloudBack:FlxTypedGroup<Cloud>;
	private var enemyParticles:FlxEmitter;
	private var pickup:FlxTypedGroup<PowerPickup>;
	private var kanata:Kanata;
	private var enemy:FlxTypedGroup<Enemy>;
	private var playerBullet:FlxTypedSpriteGroup<Halo>;
	private var cloudFront:FlxTypedGroup<Cloud>;
	private var scoreText:FlxText;
	private var powerMeter:PowerMeter;

	private var attractBox:FlxSprite;
	private var pickupBox:FlxSprite;

	private var up:FlxActionDigital;
	private var down:FlxActionDigital;
	private var left:FlxActionDigital;
	private var right:FlxActionDigital;
	private var shoot:FlxActionDigital;

	private var shootCooldown:Float = 0;
	private var score:Int = 0;

	private var enemySpawner:Spawner;

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

		pickup = new FlxTypedGroup<PowerPickup>();
		add(pickup);

		playerBullet = new FlxTypedSpriteGroup<Halo>();
		add(playerBullet);

		kanata = new Kanata(playerBullet);
		kanata.x = FlxG.width * 0.25;
		kanata.y = FlxG.height * 0.5;
		add(kanata);

		attractBox = new FlxSprite();
		attractBox.makeGraphic(PICKUP_RADIUS * 2, PICKUP_RADIUS * 2, FlxColor.TRANSPARENT);
		add(attractBox);

		pickupBox = new FlxSprite();
		pickupBox.makeGraphic(447, 60, FlxColor.TRANSPARENT);
		add(pickupBox);

		enemy = new FlxTypedGroup<Enemy>();
		add(enemy);

		cloudFront = makeCloudLayer(0.2, 0.5, -70);

		scoreText = new FlxText(40, 40);
		scoreText.size = 72;
		add(scoreText);

		powerMeter = new PowerMeter([10, 30, 90]);
		add(powerMeter);

		enemySpawner = new Spawner(enemy, onEnemyKill);
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

		// player-pickup collision
		attractBox.setPosition(kanata.x + kanata.width / 2 - PICKUP_RADIUS, kanata.y + kanata.height / 2 - PICKUP_RADIUS);
		pickupBox.setPosition(kanata.x - 386, kanata.y);
		FlxG.overlap(attractBox, pickup, onPickupRadiusHit, checkPickupRadiusHit);
		FlxG.overlap(pickupBox, pickup, onPickup);

		for (s in starBg) {
			if (s.x < -s.width) {
				s.x = s.width;
			}
		}

		enemySpawner.update(elapsed, score);
	}

	private inline function onBulletEnemyCheck(halo:Halo, enemy:Enemy) {
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
		powerMeter.value = Math.floor(powerMeter.value / 4);
		kanata.power = powerMeter.getFilled();
	}

	private inline function checkPickupRadiusHit(radius:FlxSprite, pickup:PowerPickup):Bool {
		return FlxMath.distanceBetween(radius, pickup) < radius.width / 2;
	}

	private inline function onPickupRadiusHit(radius:FlxSprite, pickup:PowerPickup) {
		pickup.attractTo(kanata);
	}

	private function onPickup(radius:FlxSprite, pickup:PowerPickup) {
		pickup.kill();
		var before = powerMeter.getFilled();
		powerMeter.value++;
		var after = powerMeter.getFilled();

		FlxG.sound.play(after > before ? AssetPaths.powerUp__wav : AssetPaths.pickup__wav);

		kanata.power = after;
	}

	private function onEnemyKill(enemy:Enemy) {
		score++;

		enemyParticles.x = enemy.x;
		enemyParticles.y = enemy.y;
		enemyParticles.width = enemy.width;
		enemyParticles.height = enemy.height;
		enemyParticles.start(true, 1, 40);

		for (i in 0...enemy.size) {
			var p = pickup.recycle(PowerPickup, PowerPickup.new);
			p.emit(enemy.x + enemy.width / 2, enemy.y + enemy.height / 2, enemy.velocity.x);
		}
	}
}
