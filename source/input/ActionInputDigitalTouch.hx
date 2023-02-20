package input;

import flixel.FlxG;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput.FlxInputDevice;
import flixel.input.actions.FlxActionInputDigital;

class ActionInputDigitalTouch extends FlxActionInputDigital {
	/**
	 * Touch action input
	 * @param	Trigger What state triggers this action (PRESSED, JUST_PRESSED, RELEASED, JUST_RELEASED)
	 */
	public function new(Trigger:FlxInputState) {
		super(FlxInputDevice.OTHER, -1, Trigger);
	}

	override public function check(Action:FlxAction):Bool {
		return switch (trigger) {
			#if !FLX_NO_TOUCH
			case PRESSED: containsMatch(FlxG.touches.list, (t) -> t.pressed);
			case RELEASED: !containsMatch(FlxG.touches.list, (t) -> t.pressed);
			case JUST_PRESSED: containsMatch(FlxG.touches.list, (t) -> t.justPressed);
			case JUST_RELEASED: containsMatch(FlxG.touches.list, (t) -> t.justReleased);
			#end
			default: false;
		}
	}

	@:generic
	private function containsMatch<T>(list:Array<T>, matcher:T->Bool) {
		for (i in list) {
			if (matcher(i)) {
				return true;
			}
		}
		return false;
	}
}
