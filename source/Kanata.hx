package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxSpriteGroup;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionManager;
import flixel.util.FlxDestroyUtil;
import input.ActionInputAnalogTouchMotion;
import input.ActionInputDigitalTouch;

class Kanata extends FlxSprite {
	private static inline var MIN_X = 150;
	private static inline var SPEED = 512.0;
	private static inline var SHOOT_COOLDOWN = 0.25;
	private static inline var HALO_SPEED = 1280;

	private var haloGroup:FlxTypedSpriteGroup<Halo>;

	private var actions:FlxActionManager;

	private var up:FlxActionDigital;
	private var down:FlxActionDigital;
	private var left:FlxActionDigital;
	private var right:FlxActionDigital;
	private var shoot:FlxActionDigital;
	private var move:FlxActionAnalog;

	private var shootCooldown:Float = 0;

	private var hitTimer:Float = 0;

	public function new(haloGroup:FlxTypedSpriteGroup<Halo>) {
		super();

		this.haloGroup = haloGroup;

		loadGraphic(AssetPaths.kanata__png, true, 519, 458);
		animation.add("spin", [for (i in 0...29) i], 24);
		animation.play("spin");
		setSize(60, 60);
		offset.set(426, 270);
		origin.set(461, 300);

		actions = FlxG.inputs.add(new FlxActionManager());

		up = new FlxActionDigital();
		down = new FlxActionDigital();
		left = new FlxActionDigital();
		right = new FlxActionDigital();
		shoot = new FlxActionDigital();
		move = new FlxActionAnalog();
		actions.addActions([up, down, left, right, shoot, move]);

		// keyboard
		up.addKey(UP, PRESSED);
		up.addKey(W, PRESSED);
		down.addKey(DOWN, PRESSED);
		down.addKey(S, PRESSED);
		left.addKey(LEFT, PRESSED);
		left.addKey(A, PRESSED);
		right.addKey(RIGHT, PRESSED);
		right.addKey(D, PRESSED);
		shoot.addKey(SPACE, PRESSED);
		shoot.addKey(Z, PRESSED);

		// gamepad
		move.addGamepad(RIGHT_ANALOG_STICK, MOVED, EITHER);
		move.addGamepad(LEFT_ANALOG_STICK, MOVED, EITHER);
		up.addGamepad(DPAD_UP, PRESSED);
		down.addGamepad(DPAD_DOWN, PRESSED);
		left.addGamepad(DPAD_LEFT, PRESSED);
		right.addGamepad(DPAD_RIGHT, PRESSED);
		shoot.addGamepad(A, PRESSED);
		shoot.addGamepad(B, PRESSED);
		shoot.addGamepad(X, PRESSED);
		shoot.addGamepad(Y, PRESSED);
		shoot.addGamepad(LEFT_TRIGGER, PRESSED);
		shoot.addGamepad(LEFT_SHOULDER, PRESSED);
		shoot.addGamepad(RIGHT_TRIGGER, PRESSED);
		shoot.addGamepad(RIGHT_SHOULDER, PRESSED);

		// touch
		move.add(new ActionInputAnalogTouchMotion(MOVED, EITHER, 5));
		shoot.add(new ActionInputDigitalTouch(PRESSED));
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		var mx = move.x;
		var my = move.y;

		if (up.triggered) {
			my = -1;
		}
		if (down.triggered) {
			my = 1;
		}
		if (left.triggered) {
			mx = -1;
		}
		if (right.triggered) {
			mx = 1;
		}

		if (mx != 0 || my != 0) {
			var dir = Math.atan2(my, mx);
			x += Math.cos(dir) * SPEED * elapsed;
			y += Math.sin(dir) * SPEED * elapsed;
		}

		if (y < 0) {
			y = 0;
		}
		if (y > FlxG.height - height) {
			y = FlxG.height - height;
		}

		if (x < MIN_X) {
			x = MIN_X;
		}
		if (x > FlxG.width - width) {
			x = FlxG.width - width;
		}

		shootCooldown -= elapsed;
		if (shoot.triggered && shootCooldown < 0) {
			shootCooldown = SHOOT_COOLDOWN;

			var b = haloGroup.recycle(Halo, Halo.new);
			b.x = x;
			b.y = y;
			b.velocity.set(HALO_SPEED);
		}

		if (hitTimer > 0) {
			hitTimer -= elapsed;
		}
	}

	override function destroy() {
		super.destroy();
		FlxG.inputs.remove(actions);
		actions = FlxDestroyUtil.destroy(actions);
	}

	override function hurt(damage:Float) {
		super.hurt(damage);
		if (hitTimer <= 0) {
			FlxFlicker.flicker(this, 1.2, 0.08);
			hitTimer = 1.3;
		}
	}
}
