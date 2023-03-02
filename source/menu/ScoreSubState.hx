package menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import score.Score;
import score.ScoreClient;

class ScoreSubState extends FlxSubState {
	private var title:FlxText;
	private var back:FlxButton;

	private var loaded:Bool = false;
	private var shown:Bool = false;

	private static var scoreList:Array<Score> = null;

	public function new() {
		super(0xA1000000);

		title = new FlxText(0, 50, -1, "Loading Scores...");
		title.setFormat(AssetPaths.Blippo_Black__otf, 100, FlxColor.WHITE);
		add(title);
		center(title);

		back = new FlxButton(20, 0, "", onBack);
		back.loadGraphic(AssetPaths.back__png);
		back.y = FlxG.height - back.height - 20;
		add(back);

		if (scoreList == null) {
			ScoreClient.listScores(onScoresLoaded);
		}
		else {
			renderScores();
		}
	}

	private function center(spr:FlxSprite) {
		spr.x = FlxG.width / 2 - spr.width / 2;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (back.status == FlxButton.NORMAL) {
			back.alpha = 0.7;
		}
		else {
			back.alpha = 1;
		}

		if (loaded && !shown) {
			shown = true;
			renderScores();
		}
	}

	private function onBack() {
		close();
	}

	private function onScoresLoaded(loadedScores:Array<Score>) {
		var names = new Array<String>();
		scoreList = new Array<Score>();

		for (s in loadedScores) {
			if (names.contains(s.name)) {
				continue;
			}

			names.push(s.name);
			scoreList.push(s);
		}

		loaded = true;
	}

	private function renderScores() {
		var maxNameWidth:Float = 0;
		var scores = new Array<FlxText>();

		var yy = 200;
		var xx = FlxG.width / 4;
		for (s in scoreList) {
			var name = new FlxText(xx, yy, -1, s.name);
			name.setFormat(AssetPaths.Blippo_Black__otf, 50, FlxColor.WHITE);
			add(name);
			maxNameWidth = Math.max(maxNameWidth, name.width);

			var score = new FlxText(xx, yy, -1, Std.string(s.value));
			score.setFormat(AssetPaths.Blippo_Black__otf, 50, FlxColor.WHITE);
			add(score);
			scores.push(score);

			yy += 70;
			if (yy + 50 > FlxG.height) {
				break;
			}
		}

		for (s in scores) {
			s.x = xx + maxNameWidth + 100;
		}

		title.text = "Recent High Scores";
		center(title);
	}
}
