package input;

import flixel.FlxG;
import flixel.input.actions.FlxActionInput.FlxInputDevice;
import flixel.input.actions.FlxActionInputAnalog;

class ActionInputAnalogTouchPosition extends FlxActionInputAnalog {
	/**
	 * Touch input -- X/Y is the touch's absolute screen position
	 * @param	Trigger What state triggers this action (MOVED, JUST_MOVED, STOPPED, JUST_STOPPED)
	 * @param	Axis which axes to monitor for triggering: X, Y, EITHER, or BOTH
	 */
	public function new(Trigger:FlxAnalogState, Axis:FlxAnalogAxis = EITHER) {
		super(FlxInputDevice.OTHER, -1, cast Trigger, Axis);
	}

	override public function update():Void {
		#if !FLX_NO_TOUCH
		var touch = FlxG.touches.getFirst();
		updateValues(touch == null ? x : touch.x, touch == null ? y : touch.y);
		#end
	}

	override function updateValues(X:Float, Y:Float):Void {
		if (X != x) {
			xMoved.press();
		}
		else {
			xMoved.release();
		}

		if (Y != y) {
			yMoved.press();
		}
		else {
			yMoved.release();
		}

		x = X;
		y = Y;
	}
}
