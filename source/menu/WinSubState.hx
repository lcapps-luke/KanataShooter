package menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;

class WinSubState extends AbstractMenuState {
	private var bg:FlxSprite;

	public function new(score:Int, lives:Float, time:Float) {
		super();

		bg = new FlxSprite(0, 0, AssetPaths.menu_large__png);
		bg.x = FlxG.width / 2 - bg.width / 2;
		bg.y = FlxG.height / 2 - bg.height / 2;
		add(bg);

		var text = new FlxText(bg.x + 150, bg.y + 63, -1, "Win", 72);
		text.color = FlxColor.BLACK;
		add(text);

		text = new FlxText(bg.x + 102, bg.y + 194, -1, 'Score: $score', 36);
		text.color = FlxColor.BLACK;
		add(text);

		var l = Math.floor(lives);
		var ls = l * 150;
		text = new FlxText(bg.x + 102, bg.y + 194 + 60, -1, 'Lives: $l x 150', 36);
		text.color = FlxColor.BLACK;
		add(text);

		var t = Math.floor(time);
		var ts = Math.max(0, 300 - t);
		text = new FlxText(bg.x + 102, bg.y + 194 + 60 * 2, -1, 'Time: $t (+$ts)', 36);
		text.color = FlxColor.BLACK;
		add(text);

		var total = score + ls + ts;
		text = new FlxText(bg.x + 102, bg.y + 194 + 60 * 3.5, -1, 'Total: $total', 36);
		text.color = FlxColor.BLACK;
		add(text);

		text = new FlxText(bg.x + 66, bg.y + 490, -1, "Restart", 48);
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
