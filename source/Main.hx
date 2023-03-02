package;

import flixel.FlxG;
import flixel.FlxGame;
import itch.ItchUtilities;
import openfl.display.Sprite;

class Main extends Sprite {
	public static var username:String = "anonymous";
	public static var itchId:Null<Int> = null;

	public function new() {
		super();

		var game = new FlxGame(1920, 1080, PlayState, 60, 60, true);

		FlxG.sound.volume = 0.3;

		#if !FLX_NO_MOUSE
		FlxG.mouse.useSystemCursor = true;
		#end

		addChild(game);

		ItchUtilities.getUser(function(name, id) {
			username = name;
			itchId = id;
		});
	}
}
