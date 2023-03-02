package menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxInputText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import score.ScoreClient;

class SubmitScoreSubState extends AbstractMenuState {
	public var sent(default, null):Bool = false;

	private var token:String;
	private var score:Int;
	private var proof:String;

	private var bg:FlxSprite;
	private var nameInput:FlxInputText;
	private var submit:FlxButton;

	public function new(score:Int, lives:Float, time:Float, token:String, total:Int) {
		super();
		this.bgColor = 0xA1000000;

		this.token = token;
		this.score = total;
		this.proof = '$score:$lives:$time';
	}

	override function create() {
		super.create();

		bg = new FlxSprite(0, 0, AssetPaths.menu_small__png);
		bg.x = FlxG.width / 2 - bg.width / 2;
		bg.y = FlxG.height / 2 - bg.height / 2;
		add(bg);

		var back = new FlxButton(20, 0, "", onBack);
		back.loadGraphic(AssetPaths.back__png);
		back.y = FlxG.height - back.height - 20;
		add(back);

		nameInput = new FlxInputText(0, 0, 420, Main.username, 50); // , 0x000000, 0xFFFFFF);
		// nameInput.setFormat(AssetPaths.Blippo_Black__otf, 72, 0x000000);
		nameInput.caretWidth = 10;
		nameInput.maxLength = 20;
		nameInput.x = bg.x + bg.width / 2 - nameInput.width / 2;
		nameInput.y = bg.y + bg.height / 2 - nameInput.height / 2 - 20;
		nameInput.textField.needsSoftKeyboard = true;
		add(nameInput);

		submit = new FlxButton(0, 0, "Submit", onSubmit);
		submit.makeGraphic(250, 50, FlxColor.TRANSPARENT);
		submit.label.setFormat(AssetPaths.Blippo_Black__otf, 50, FlxColor.BLACK);
		submit.x = bg.x + bg.width / 2 - submit.width / 2;
		submit.y = bg.y + bg.height - submit.height - 70;
		add(submit);
	}

	private function navigateConfirm() {}

	private function onSubmit() {
		remove(submit);
		sent = true;

		Main.username = nameInput.text;

		ScoreClient.submit(token, nameInput.text, score, function(success) {
			ScoreSubState.clearCache();
			close();
		}, Std.string(Main.itchId));
	}

	private function onBack() {
		close();
	}
}
