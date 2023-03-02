package menu;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionManager;
import flixel.math.FlxPoint;
import flixel.util.FlxCollision;
import flixel.util.FlxDestroyUtil;
import flixel.util.helpers.FlxBounds;
import flixel.util.helpers.FlxPointRangeBounds;
import input.ActionInputAnalogTouchPosition;
import input.ActionInputDigitalTouch;
import openfl.geom.Point;

abstract class AbstractMenuState extends FlxSubState {
	private var actions:FlxActionManager;
	private var buttonPressed:FlxActionDigital;
	private var buttonReleased:FlxActionDigital;
	private var buttonBlocked = true;

	private var analogPosition:FlxActionAnalog;
	private var pointerPressed:FlxActionDigital;
	private var pointerReleased:FlxActionDigital;
	private var pointerBlocked = true;

	private var pointerX:Float = 0;
	private var pointerY:Float = 0;

	private var delay:Float = 0.5;

	private function new() {
		super();

		buttonPressed = new FlxActionDigital();
		buttonPressed.addKey(SPACE, PRESSED);
		buttonPressed.addKey(Z, PRESSED);
		buttonPressed.addGamepad(A, PRESSED);
		buttonPressed.addGamepad(B, PRESSED);
		buttonPressed.addGamepad(X, PRESSED);
		buttonPressed.addGamepad(Y, PRESSED);

		buttonReleased = new FlxActionDigital();
		buttonReleased.addKey(SPACE, JUST_RELEASED);
		buttonReleased.addKey(Z, JUST_RELEASED);
		buttonReleased.addGamepad(A, JUST_RELEASED);
		buttonReleased.addGamepad(B, JUST_RELEASED);
		buttonReleased.addGamepad(X, JUST_RELEASED);
		buttonReleased.addGamepad(Y, JUST_RELEASED);

		analogPosition = new FlxActionAnalog();
		analogPosition.addMousePosition(MOVED, EITHER);
		analogPosition.add(new ActionInputAnalogTouchPosition(MOVED, EITHER));

		pointerPressed = new FlxActionDigital();
		pointerPressed.addMouse(LEFT, PRESSED);
		pointerPressed.add(new ActionInputDigitalTouch(PRESSED));

		pointerReleased = new FlxActionDigital();
		pointerReleased.addMouse(LEFT, JUST_RELEASED);
		pointerReleased.add(new ActionInputDigitalTouch(JUST_RELEASED));
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		buttonPressed.update();
		buttonReleased.update();
		analogPosition.update();
		pointerPressed.update();
		pointerReleased.update();

		if (analogPosition.triggered) {
			pointerX = analogPosition.x;
			pointerY = analogPosition.y;
		}

		if (delay > 0) {
			delay -= elapsed;
			return;
		}

		if (!buttonPressed.triggered) {
			buttonBlocked = false;
		}

		if (!pointerPressed.triggered) {
			pointerBlocked = false;
		}

		if (buttonReleased.triggered && !buttonBlocked) {
			navigateConfirm();
		}
	}

	override function destroy() {
		super.destroy();

		actions = FlxDestroyUtil.destroy(actions);
	}

	public function checkClicked(spr:FlxSprite, pixelPerfect:Bool = true) {
		return pointerReleased.triggered
			&& !pointerBlocked
			&& (pixelPerfect ? FlxCollision.pixelPerfectPointCheck(Math.round(pointerX), Math.round(pointerY),
				spr) : spr.overlapsPoint(FlxPoint.weak(pointerX, pointerY)));
	}

	abstract private function navigateConfirm():Void;
}
