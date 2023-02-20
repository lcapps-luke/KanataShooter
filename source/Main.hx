package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();

		var game = new FlxGame(1920, 1080, PlayState, 60, 60, true);

		FlxG.sound.volume = 0.3;

		#if !FLX_NO_MOUSE
		FlxG.mouse.useSystemCursor = true;
		#end

		addChild(game);
	}
}
