package menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;

class GameOverSubState extends AbstractMenuState {
	private var bg:FlxSprite;

	public function new() {
		super();

		bg = new FlxSprite(0, 0, AssetPaths.menu_small__png);
		bg.x = FlxG.width / 2 - bg.width / 2;
		bg.y = FlxG.height / 2 - bg.height / 2;
		add(bg);

		var text = new FlxText(bg.x + 116, bg.y + 94, -1, "Game Over", 48);
		text.color = FlxColor.BLACK;
		add(text);

		text = new FlxText(bg.x + 216, bg.y + 214, -1, "Retry", 36);
		text.color = FlxColor.BLACK;
		add(text);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (pointerClick.triggered) {
			if (FlxCollision.pixelPerfectPointCheck(Math.round(pointerX), Math.round(pointerY), bg)) {
				FlxG.switchState(new PlayState());
			}
		}

		if (buttonClick.triggered) {
			FlxG.switchState(new PlayState());
		}
	}
}
