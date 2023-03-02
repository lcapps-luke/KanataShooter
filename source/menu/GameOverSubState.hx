package menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class GameOverSubState extends AbstractMenuState {
	private var bg:FlxSprite;

	public function new() {
		super();

		bg = new FlxSprite(0, 0, AssetPaths.menu_small__png);
		bg.x = FlxG.width / 2 - bg.width / 2;
		bg.y = FlxG.height / 2 - bg.height / 2;
		add(bg);

		var title = new TitleText(bg.x + 80, bg.y + 94, "Game Over", 72);
		add(title);

		var text = new FlxText(bg.x + 227, bg.y + 214, -1, "Retry", 36);
		text.setFormat(AssetPaths.Blippo_Black__otf, 36, FlxColor.BLACK);
		add(text);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (checkClicked(bg)) {
			navigateConfirm();
		}
	}

	private function navigateConfirm() {
		FlxG.switchState(new PlayState());
	}
}
