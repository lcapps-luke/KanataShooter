package menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;

class InitialSubState extends AbstractMenuState {
	private var bg:FlxSprite;

	public function new() {
		super();

		bg = new FlxSprite(0, 0, AssetPaths.menu_small__png);
		bg.x = FlxG.width / 2 - bg.width / 2;
		bg.y = FlxG.height / 2 - bg.height / 2;
		add(bg);

		var text = new FlxText(0, 0, -1, "Play", 72);
		text.color = FlxColor.BLACK;
		text.x = FlxG.width / 2 - text.width / 2;
		text.y = FlxG.height / 2 - text.height / 2;
		add(text);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (pointerClick.triggered) {
			if (FlxCollision.pixelPerfectPointCheck(Math.round(pointerX), Math.round(pointerY), bg)) {
				close();
			}
		}

		if (buttonClick.triggered) {
			close();
		}
	}
}
