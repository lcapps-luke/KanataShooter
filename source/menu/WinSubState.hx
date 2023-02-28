package menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;

class WinSubState extends AbstractMenuState {
	private static inline var SCORE_SIZE = 50;

	private var bg:FlxSprite;

	public function new(score:Int, lives:Float, time:Float) {
		super();

		bg = new FlxSprite(0, 0, AssetPaths.menu_large__png);
		bg.x = FlxG.width / 2 - bg.width / 2;
		bg.y = FlxG.height / 2 - bg.height / 2;
		add(bg);

		var title = new TitleText(bg.x + 150, bg.y + 63, "Win", 76);
		add(title);

		var text = new FlxText(bg.x + 102, bg.y + 194, -1, 'Score: $score');
		text.setFormat(AssetPaths.Blippo_Black__otf, SCORE_SIZE, FlxColor.BLACK);
		add(text);

		var l = Math.floor(lives);
		var ls = l * 150;
		text = new FlxText(bg.x + 102, bg.y + 194 + 60, -1, 'Lives: $l x 150');
		text.setFormat(AssetPaths.Blippo_Black__otf, SCORE_SIZE, FlxColor.BLACK);
		add(text);

		var t = Math.floor(time);
		var ts = Math.max(0, 300 - t);
		text = new FlxText(bg.x + 102, bg.y + 194 + 60 * 2, -1, 'Time: $t (+$ts)');
		text.setFormat(AssetPaths.Blippo_Black__otf, SCORE_SIZE, FlxColor.BLACK);
		add(text);

		var total = score + ls + ts;
		text = new FlxText(bg.x + 102, bg.y + 194 + 60 * 3.5, -1, 'Total: $total');
		text.setFormat(AssetPaths.Blippo_Black__otf, SCORE_SIZE, FlxColor.BLACK);
		add(text);

		text = new FlxText(bg.x + 66, bg.y + 490, -1, "Restart");
		text.setFormat(AssetPaths.Blippo_Black__otf, 60, FlxColor.BLACK);
		add(text);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (checkClicked(bg)) {
			navigateConfirm();
		}
	}

	function navigateConfirm() {
		FlxG.switchState(new PlayState());
	}
}
