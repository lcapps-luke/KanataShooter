package utils.ui;

import flixel.FlxG;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

/**
 * https://github.com/HaxeFlixel/flixel-ui/issues/70#issuecomment-1035841072
**/
#if !mobile
typedef GFTextInput = FlxInputText;
#else
class GFTextInput extends FlxGroup {
	public final inputText:FlxInputText;

	private final _flTextField:openfl.text.TextField;
	private final clickArea:ClickArea;

	public var x(default, set):Float;
	public var y(default, set):Float;
	public var maxLength(default, set):Int;
	public var text(get, set):String;
	public var width(get, null):Float;
	public var height(get, null):Float;
	public var caretWidth(default, set):Int;

	public function new(X:Float = 0, Y:Float = 0, Width:Int = 150, ?Text:String, size:Int = 8, TextColor:Int = FlxColor.BLACK,
			BackgroundColor:Int = FlxColor.WHITE, EmbeddedFont:Bool = true) {
		super();
		x = X;
		y = Y;
		inputText = new FlxInputText(x, y, Width, Text, size, TextColor, BackgroundColor, EmbeddedFont);
		_flTextField = new openfl.text.TextField();
		_flTextField.needsSoftKeyboard = true;
		_flTextField.text = text;
		_flTextField.x = x;
		_flTextField.y = y;
		_flTextField.type = openfl.text.TextFieldType.INPUT;
		_flTextField.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, function(e:openfl.events.KeyboardEvent) {
			if (inputText.maxLength == 0 || _flTextField.text.length <= inputText.maxLength)
				inputText.text = _flTextField.text;
			if (e.keyCode == 13)
				FlxG.stage.focus = null;
		});
		clickArea = new ClickArea(x, y, Width, inputText.height, function() {
			text = '';
			FlxG.stage.focus = _flTextField;
		});
		add(inputText);
		add(clickArea);
		FlxG.addChildBelowMouse(_flTextField);
	}

	public override function update(elapsed) {
		if (inputText.maxLength == 0 || _flTextField.text.length <= inputText.maxLength)
			inputText.text = _flTextField.text;
		super.update(elapsed);
	}

	public function set_x(v:Float) {
		if (inputText != null)
			inputText.x = v;

		if (clickArea != null)
			clickArea.x = v;

		return x = v;
	}

	public function set_y(v:Float) {
		if (inputText != null)
			inputText.y = v;

		if (clickArea != null)
			clickArea.y = v;

		return y = v;
	}

	function set_text(value:String):String {
		inputText.text = value;
		_flTextField.text = value;

		return value;
	}

	function get_text():String {
		return inputText.text;
	}

	function set_maxLength(v:Int):Int {
		return maxLength = inputText.maxLength = v;
	}

	function get_width():Float {
		return inputText.width;
	}

	function get_height():Float {
		return inputText.height;
	}

	function set_caretWidth(v:Int):Int {
		return caretWidth = inputText.caretWidth = v;
	}

	public override function destroy() {
		FlxG.removeChild(_flTextField);
	}
}
#end
