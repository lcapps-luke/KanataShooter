package menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class InitialSubState extends AbstractMenuState {
	private var bg:FlxSprite;
	private var scoreButton:FlxSprite;

	public function new() {
		super();

		bg = new FlxSprite(0, 0, AssetPaths.menu_small__png);
		bg.x = FlxG.width / 2 - bg.width / 2;
		bg.y = FlxG.height / 2 - bg.height / 2;
		add(bg);

		var text = new TitleText(0, 0, "Play", 72);
		text.x = FlxG.width / 2 - text.width / 2;
		text.y = FlxG.height / 2 - text.height / 2;
		add(text);

		scoreButton = new FlxSprite(0, 40, AssetPaths.menu_mini__png);
		scoreButton.x = FlxG.width - scoreButton.width - 40;
		add(scoreButton);

		var scoreTxt = new FlxText(0, 0, -1, "High Scores");
		scoreTxt.setFormat(AssetPaths.Blippo_Black__otf, 50, FlxColor.BLACK);
		scoreTxt.x = scoreButton.x + scoreButton.width / 2 - scoreTxt.width / 2;
		scoreTxt.y = scoreButton.y + scoreButton.height / 2 - scoreTxt.height / 2 + 10;
		add(scoreTxt);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (checkClicked(bg)) {
			navigateConfirm();
		}

		if (checkClicked(scoreButton)) {
			navigateScores();
		}
	}

	private function navigateConfirm() {
		close();
	}

	private function navigateScores() {
		openSubState(new ScoreSubState());
	}
}
