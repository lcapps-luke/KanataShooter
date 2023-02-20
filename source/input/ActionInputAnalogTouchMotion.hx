package input;

import flixel.FlxG;
import flixel.input.actions.FlxActionInput.FlxInputDevice;
import flixel.input.actions.FlxActionInputAnalog;

class ActionInputAnalogTouchMotion extends FlxActionInputAnalog {
	var lastX:Float = 0;
	var lastY:Float = 0;
	var pixelsPerUnit:Int;
	var deadZone:Float;
	var invertX:Bool;
	var invertY:Bool;

	/**
	 * Touch input -- X/Y is the RELATIVE motion of the first touch since the last frame
	 * @param	Trigger	What state triggers this action (MOVED, JUST_MOVED, STOPPED, JUST_STOPPED)
	 * @param	Axis	which axes to monitor for triggering: X, Y, EITHER, or BOTH
	 * @param	PixelsPerUnit	How many pixels of movement = 1.0 in analog motion (lower: more sensitive, higher: less sensitive)
	 * @param	DeadZone	Minimum analog value before motion will be reported
	 * @param	InvertY	Invert the Y axis
	 * @param	InvertX	Invert the X axis
	 */
	public function new(Trigger:FlxAnalogState, Axis:FlxAnalogAxis = EITHER, PixelsPerUnit:Int = 10, DeadZone:Float = 0.1, InvertY:Bool = false,
			InvertX:Bool = false) {
		pixelsPerUnit = PixelsPerUnit;
		if (pixelsPerUnit < 1)
			pixelsPerUnit = 1;
		deadZone = DeadZone;
		invertX = InvertX;
		invertY = InvertY;
		super(FlxInputDevice.OTHER, -1, cast Trigger, Axis);
	}

	override public function update():Void {
		#if !FLX_NO_TOUCH
		var touch = FlxG.touches.getFirst();
		if (touch != null) {
			if (touch.justPressed) {
				lastX = touch.x;
				lastY = touch.y;
			}
			else {
				updateXYPosition(touch.x, touch.y);
			}
		}
		#end
	}

	function updateXYPosition(X:Float, Y:Float):Void {
		var xDiff = X - lastX;
		var yDiff = Y - lastY;

		lastX = X;
		lastY = Y;

		if (invertX)
			xDiff *= -1;
		if (invertY)
			yDiff *= -1;

		xDiff /= (pixelsPerUnit);
		yDiff /= (pixelsPerUnit);

		if (Math.abs(xDiff) < deadZone)
			xDiff = 0;
		if (Math.abs(yDiff) < deadZone)
			yDiff = 0;

		updateValues(xDiff, yDiff);
	}
}
