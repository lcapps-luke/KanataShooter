package menu;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;

class TitleText extends FlxTypedSpriteGroup<FlxText> {
	private static inline var OFFSET:Float = 0.03;

	public var text(get, set):String;
	public var size(get, set):Int;

	private var white:FlxText;
	private var red:FlxText;
	private var green:FlxText;
	private var blue2:FlxText;
	private var blue:FlxText;

	public function new(x:Float, y:Float, text:String, size:Int) {
		super(x, y);

		blue = new FlxText(-OFFSET * size, OFFSET * size, -1, text);
		blue.setFormat(AssetPaths.Blippo_Black__otf, size, 0xFF5F2FCB);
		add(blue);

		blue2 = new FlxText(0, OFFSET * size * 2, -1, text);
		blue2.setFormat(AssetPaths.Blippo_Black__otf, size, 0xFF5F2FCB);
		add(blue2);

		green = new FlxText(0, -OFFSET * size, -1, text);
		green.setFormat(AssetPaths.Blippo_Black__otf, size, 0xFF7CCBD1);
		add(green);

		red = new FlxText(OFFSET * size, OFFSET * size, -1, text);
		red.setFormat(AssetPaths.Blippo_Black__otf, size, 0xFFFF71A9);
		add(red);

		white = new FlxText(0, 0, -1, text);
		white.setFormat(AssetPaths.Blippo_Black__otf, size, 0xFFFFFFFF);
		add(white);
	}

	private function get_text():String {
		return white.text;
	}

	private function set_text(v:String):String {
		white.text = v;
		red.text = v;
		green.text = v;
		blue.text = v;
		blue2.text = v;
		return v;
	}

	private function get_size():Int {
		return white.size;
	}

	private function set_size(v:Int):Int {
		white.size = v;
		red.size = v;
		green.size = v;
		blue.size = v;
		blue2.size = v;

		blue.setPosition(-OFFSET * v, OFFSET * v);
		blue2.setPosition(0, OFFSET * v * 2);
		green.setPosition(0, -OFFSET * v);
		red.setPosition(OFFSET * v, OFFSET * v);

		return v;
	}
}
