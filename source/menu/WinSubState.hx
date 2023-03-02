package menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class WinSubState extends AbstractMenuState {
	private static inline var SCORE_SIZE = 50;

	private var bg:FlxSprite;
	private var scoreButton:FlxSprite;

	private var score:Int;
	private var lives:Float;
	private var time:Float;
	private var token:String;
	private var totalScore:Int = 0;

	private var scoreState:SubmitScoreSubState;

	public function new(score:Int, lives:Float, time:Float, token:String) {
		super();

		this.score = score;
		this.lives = lives;
		this.time = time;
		this.token = token;

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
		var ts = FlxMath.maxInt(0, 300 - t);
		text = new FlxText(bg.x + 102, bg.y + 194 + 60 * 2, -1, 'Time: $t (+$ts)');
		text.setFormat(AssetPaths.Blippo_Black__otf, SCORE_SIZE, FlxColor.BLACK);
		add(text);

		totalScore = score + ls + ts;
		text = new FlxText(bg.x + 102, bg.y + 194 + 60 * 3.5, -1, 'Total: $totalScore');
		text.setFormat(AssetPaths.Blippo_Black__otf, SCORE_SIZE, FlxColor.BLACK);
		add(text);

		text = new FlxText(bg.x + 66, bg.y + 490, -1, "Restart");
		text.setFormat(AssetPaths.Blippo_Black__otf, 60, FlxColor.BLACK);
		add(text);

		if (token != null) {
			scoreButton = new FlxSprite(0, 40, AssetPaths.menu_mini__png);
			scoreButton.x = FlxG.width - scoreButton.width - 40;
			add(scoreButton);

			var scoreTxt = new FlxText(0, 0, -1, "Submit Score");
			scoreTxt.setFormat(AssetPaths.Blippo_Black__otf, 50, FlxColor.BLACK);
			scoreTxt.x = scoreButton.x + scoreButton.width / 2 - scoreTxt.width / 2;
			scoreTxt.y = scoreButton.y + scoreButton.height / 2 - scoreTxt.height / 2 + 10;
			add(scoreTxt);
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (checkClicked(bg)) {
			navigateConfirm();
		}

		if (checkClicked(scoreButton)) {
			onSubmitScore();
		}
	}

	private function navigateConfirm() {
		FlxG.switchState(new PlayState());
	}

	private function onSubmitScore() {
		scoreState = new SubmitScoreSubState(score, lives, time, token, totalScore);
		scoreState.closeCallback = function() {
			if (scoreState.sent) {
				FlxG.switchState(new PlayState());
			}
		}
		openSubState(scoreState);
	}
}
