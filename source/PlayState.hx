package;

import enemy.Enemy;
import enemy.Spawner;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;
import menu.GameOverSubState;
import menu.InitialSubState;
import menu.TitleText;
import menu.WinSubState;
import score.ScoreClient;

class PlayState extends FlxState {
	private static inline var SPEED = 512.0;
	private static inline var SHOOT_COOLDOWN = 0.25;
	private static inline var HALO_SPEED = 1280;
	private static inline var PICKUP_RADIUS = 240;

	private static var firstPlay = true;

	private var starBg:Array<FlxSprite> = [];
	private var cloudBack:FlxTypedGroup<Cloud>;
	private var enemyParticles:FlxEmitter;
	private var pickup:FlxTypedGroup<PowerPickup>;
	private var kanata:Kanata;
	private var boss:FlxSpriteGroup;
	private var enemy:FlxTypedGroup<Enemy>;
	private var playerBullet:FlxTypedSpriteGroup<Halo>;
	private var cloudFront:FlxTypedGroup<Cloud>;
	private var scoreText:TitleText;
	private var powerMeter:PowerMeter;
	private var hearts:Array<FlxSprite>;
	private var bossHealthBar:Array<FlxSprite>;

	private var attractBox:FlxSprite;
	private var pickupBox:FlxSprite;
	private var hitBox:FlxSprite;

	private var up:FlxActionDigital;
	private var down:FlxActionDigital;
	private var left:FlxActionDigital;
	private var right:FlxActionDigital;
	private var shoot:FlxActionDigital;

	private var shootCooldown:Float = 0;
	private var progress:Int = 0;
	private var score:Int = 0;
	private var lives:Int = 3;
	private var playTime:Float = 0;

	private var enemySpawner:Spawner;
	private var bossKilled:Bool = false;
	private var gameOver:Bool = false;
	private var gameEndTimer:Float = 3;

	private var scoreToken:String = null;

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

		hitBox = new FlxSprite(0, 0, AssetPaths.boss_bullet__png);
		hitBox.visible = false;
		add(hitBox);

		boss = new FlxSpriteGroup();
		add(boss);

		enemy = new FlxTypedGroup<Enemy>();
		add(enemy);

		cloudFront = makeCloudLayer(0.2, 0.5, -70);

		scoreText = new TitleText(40, 20, "0", 90);
		add(scoreText);

		powerMeter = new PowerMeter([10, 30, 70]);
		add(powerMeter);

		hearts = new Array<FlxSprite>();
		for (i in 0...3) {
			var hx = FlxG.width / 2 - (5 * 69) / 2 + (69 * 2 * i);
			var h = new FlxSprite(hx, 40, AssetPaths.heart__png);
			add(h);
			hearts.push(h);
		}

		bossHealthBar = new Array<FlxSprite>();
		var barInner = new FlxSprite(1280, 40);
		barInner.makeGraphic(FlxG.width - 1280 - 40, 69);
		barInner.origin.set(0, 0);
		barInner.visible = false;
		add(barInner);
		bossHealthBar.push(barInner);
		var barOuter = new FlxSprite(1280, 40);
		barOuter.makeGraphic(FlxG.width - 1280 - 40, 69, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRect(barOuter, 0, 0, barOuter.width, barOuter.height, FlxColor.TRANSPARENT, {thickness: 6, color: FlxColor.WHITE});
		barOuter.visible = false;
		add(barOuter);
		bossHealthBar.push(barOuter);

		if (firstPlay) {
			firstPlay = false;
			persistentUpdate = true;
			var menu = new InitialSubState();
			menu.closeCallback = function() {
				startGame();
			}
			openSubState(menu);
		}
		else {
			startGame();
		}
	}

	private function startGame() {
		ScoreClient.getToken(function(token) {
			this.scoreToken = token;
		});

		enemySpawner = new Spawner(enemy, onEnemyKill, boss);
		playTime = 0;
	}

	private inline function makeStarLayer(speed:Int, flip:Bool = false) {
		var a = new FlxSprite(0, 0, AssetPaths.stars__png);
		a.velocity.set(speed);
		a.solid = false;
		add(a);
		starBg.push(a);

		var b = new FlxSprite(a.width, 0, AssetPaths.stars__png);
		b.velocity.set(speed);
		b.solid = false;
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
		playTime += elapsed;

		if (gameOver) {
			gameEndTimer -= elapsed;
			if (gameEndTimer < 0) {
				persistentUpdate = false;

				if (bossKilled) {
					firstPlay = true;
					openSubState(new WinSubState(score, kanata.health, playTime, scoreToken));
				}
				else {
					openSubState(new GameOverSubState());
				}
			}
		}

		// bullet-enemy collision
		FlxG.overlap(playerBullet, enemy, onBulletEnemyOverlap, onBulletEnemyCheck);

		// enemy-player collision
		hitBox.x = kanata.x;
		hitBox.y = kanata.y;
		FlxG.overlap(hitBox, enemy, onPlayerHit, checkPlayerHit);

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

		if (enemySpawner != null) {
			enemySpawner.update(elapsed, progress);

			if (enemySpawner.bossSpawned) {
				bossHealthBar[0].visible = true;
				bossHealthBar[0].scale.set(enemySpawner.getBossHealth(), 1);
				bossHealthBar[1].visible = true;
			}
		}
	}

	private inline function onBulletEnemyCheck(halo:Halo, enemy:Enemy) {
		if (enemy.canKill) {
			return FlxG.pixelPerfectOverlap(halo, enemy);
		}
		return false;
	}

	private function onBulletEnemyOverlap(halo:Halo, enemy:Enemy) {
		halo.kill();
		enemy.hurt(1);
	}

	private inline function checkPlayerHit(player:FlxSprite, enemy:Enemy) {
		return FlxG.pixelPerfectOverlap(player, enemy);
	}

	private function onPlayerHit(player:FlxSprite, enemy:Enemy) {
		if (enemy.dieOnPlayerHit) {
			enemy.kill();
		}
		kanata.hurt(1);
		if (!kanata.alive) {
			kanata.kill();
			attractBox.kill();
			pickupBox.kill();
			hitBox.kill();
			gameOver = true;
		}

		var filled = powerMeter.getFilled();
		var filledQty = powerMeter.getQty(filled - 1);
		powerMeter.value = FlxMath.maxInt(filledQty - 5 * filled, 0);

		kanata.power = powerMeter.getFilled();

		for (i in 0...hearts.length) {
			hearts[i].visible = kanata.health > i;
		}
	}

	private inline function checkPickupRadiusHit(radius:FlxSprite, pickup:PowerPickup):Bool {
		return FlxMath.distanceBetween(radius, pickup) < radius.width / 2;
	}

	private inline function onPickupRadiusHit(radius:FlxSprite, pickup:PowerPickup) {
		pickup.attractTo(kanata);
	}

	private function onPickup(radius:FlxSprite, pickup:PowerPickup) {
		score += 1;

		pickup.kill();
		var before = powerMeter.getFilled();
		powerMeter.value++;
		var after = powerMeter.getFilled();

		FlxG.sound.play(after > before ? AssetPaths.powerUp__wav : AssetPaths.pickup__wav);

		kanata.power = after;
	}

	private function onEnemyKill(enemy:Enemy) {
		progress++;
		score += enemy.size * 10;

		enemyParticles.x = enemy.x;
		enemyParticles.y = enemy.y;
		enemyParticles.width = enemy.width;
		enemyParticles.height = enemy.height;
		enemyParticles.start(true, 1, 40);

		for (i in 0...enemy.size) {
			var p = pickup.recycle(PowerPickup, PowerPickup.new);

			var px = enemy.x + FlxG.random.float(enemy.width * 0.25, enemy.width * 0.75);
			var py = enemy.y + FlxG.random.float(enemy.height * 0.25, enemy.height * 0.75);

			p.emit(px, py, enemy.velocity.x);
		}

		if (enemy.isBoss) {
			bossKilled = true;
			gameOver = true;
		}
	}
}
