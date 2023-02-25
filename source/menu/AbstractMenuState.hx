package menu;

import flixel.FlxSubState;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionManager;
import flixel.system.replay.MouseRecord;
import flixel.util.FlxDestroyUtil;
import input.ActionInputAnalogTouchPosition;
import input.ActionInputDigitalTouch;

abstract class AbstractMenuState extends FlxSubState {
	private var actions:FlxActionManager;
	private var buttonClick:FlxActionDigital;
	private var analogPosition:FlxActionAnalog;
	private var pointerClick:FlxActionDigital;
	private var pointerX:Float = 0;
	private var pointerY:Float = 0;

	private function new() {
		super();
		buttonClick = new FlxActionDigital();
		buttonClick.addKey(SPACE, JUST_RELEASED);
		buttonClick.addKey(Z, JUST_RELEASED);
		buttonClick.addGamepad(A, JUST_RELEASED);
		buttonClick.addGamepad(B, JUST_RELEASED);
		buttonClick.addGamepad(X, JUST_RELEASED);
		buttonClick.addGamepad(Y, JUST_RELEASED);

		analogPosition = new FlxActionAnalog();
		analogPosition.addMousePosition(MOVED, EITHER);
		analogPosition.add(new ActionInputAnalogTouchPosition(MOVED, EITHER));
		pointerClick = new FlxActionDigital();
		pointerClick.addMouse(LEFT, JUST_RELEASED);
		pointerClick.add(new ActionInputDigitalTouch(JUST_RELEASED));
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		buttonClick.update();
		analogPosition.update();
		pointerClick.update();

		if (analogPosition.triggered) {
			pointerX = analogPosition.x;
			pointerY = analogPosition.y;
		}
	}

	override function destroy() {
		super.destroy();

		actions = FlxDestroyUtil.destroy(actions);
	}
}
