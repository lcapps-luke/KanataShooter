package enemy;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class BossEnemy extends Enemy {
	public static inline var MAX_HEALTH:Float = 200;

	private static inline var CENTER_Y:Float = 350;
	private static inline var MOUTH_X:Float = 24;
	private static inline var MOUTH_Y:Float = 354;
	private static inline var EYES_X:Float = 18;
	private static inline var EYES_Y:Float = 222;
	private static inline var STEP_Y:Float = 70;
	private static inline var STEP_SPEED:Float = 3.14 / 4;
	private static inline var SHOOT_X:Float = MOUTH_X + 45;
	private static inline var SHOOT_Y:Float = MOUTH_Y + 75;

	private var body:FlxSprite;
	private var mouth:FlxSprite;
	private var eyes:FlxSprite;

	private var blinkTimer:Float = 0;
	private var walkCycle:Float = 0;
	private var targetPositionTimer:Float = 0;
	private var targetPosition:Float = 0;

	private var attackTimer:Float = 7;
	private var attacking:Bool = false;

	public function new(visualGroup:FlxSpriteGroup) {
		super(FlxG.width, FlxG.height / 2 - CENTER_Y, AssetPaths.boss_body__png);
		visible = false;
		health = MAX_HEALTH;
		size = 100;
		dieOnPlayerHit = false;
		isBoss = true;

		body = new FlxSprite(x, y, AssetPaths.boss_body__png);
		visualGroup.add(body);

		mouth = new FlxSprite(x + MOUTH_X, y + MOUTH_Y);
		mouth.loadGraphic(AssetPaths.boss_mouth__png, true, 117, 128);
		mouth.animation.add("open", [0, 1, 2, 3, 4], 12, false);
		mouth.animation.add("close", [4, 3, 2, 1, 0], 24, false);
		mouth.animation.finishCallback = onMouthAnimationFinished;
		visualGroup.add(mouth);

		eyes = new FlxSprite(x + EYES_X, y + EYES_Y);
		eyes.loadGraphic(AssetPaths.boss_eyes__png, true, 136, 90);
		eyes.animation.add("blink", [0, 1, 0], 12, false);
		visualGroup.add(eyes);

		this.maxVelocity.set(100, 100);
		this.drag.set(200, 200);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		blinkTimer -= elapsed;
		if (blinkTimer < 0) {
			blinkTimer = FlxG.random.float(0.75, 5);
			eyes.animation.play("blink");
		}

		walkCycle += STEP_SPEED * elapsed;
		this.y = FlxG.height / 2 - CENTER_Y + (Math.cos(walkCycle) * STEP_Y);

		targetPositionTimer -= elapsed;
		if (targetPositionTimer < 0) {
			targetPosition = FlxG.random.float(FlxG.width - width * 0.75, FlxG.width - width * 0.5);
			targetPositionTimer = FlxG.random.float(1, 3);
		}

		if (Math.abs(x - targetPosition) < 20) {
			targetPosition = FlxG.random.float(FlxG.width - width * 0.75, FlxG.width - width * 0.5);
		}
		else {
			this.acceleration.set(targetPosition > x ? 100 : -100);
		}

		attackTimer -= elapsed;
		if (attackTimer < 0) {
			attacking = true;
			mouth.animation.play("open");

			attackTimer = FlxG.random.float(2, 5);
		}

		body.x = x;
		body.y = y;
		mouth.x = x + MOUTH_X;
		mouth.y = y + MOUTH_Y;
		eyes.x = x + EYES_X;
		eyes.y = y + EYES_Y;
	}

	override function kill() {
		super.kill();

		body.kill();
		mouth.kill();
		eyes.kill();
	}

	private function onMouthAnimationFinished(name:String) {
		if (attacking) {
			mouth.animation.play("close", false);
			attacking = false;

			for (i in 0...5) {
				var b = group.recycle(BossBullet, BossBullet.new);
				b.reset(x + SHOOT_X - b.width / 2, y + SHOOT_Y - b.height / 2);
				b.velocity.rotateByDegrees(FlxG.random.float(-80, 80));
			}
		}
	}
}
