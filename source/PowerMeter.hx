package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class PowerMeter extends FlxTypedGroup<FlxSprite> {
	public var value(default, set):Int = 0;

	private var meter = new Array<FlxSprite>();
	private var qty:Array<Int>;

	public function new(qty:Array<Int>) {
		super();

		this.qty = qty;

		var xIncr = 84 + 20;
		var yy = FlxG.height - 84 - 40;

		for (i in 0...qty.length) {
			makePart(40 + xIncr * i, yy);
		}
	}

	private function makePart(x:Float, y:Float) {
		var m = new FlxSprite(x, y, AssetPaths.power_fill__png);
		m.setSize(1, 1);
		m.centerOffsets(true);
		m.scale.set(0, 0);
		add(m);
		meter.push(m);

		var p = new FlxSprite(x, y, AssetPaths.power_outline__png);
		add(p);
	}

	public function getFilled():Int {
		var offset = 0;
		var fill = 0;
		for (i in 0...qty.length) {
			if (value >= offset + qty[i]) {
				fill++;
			}
			else {
				break;
			}

			offset += qty[i];
		}

		return fill;
	}

	private function set_value(v:Int):Int {
		var offset = 0;
		for (i in 0...qty.length) {
			var sz = Math.max(0, Math.min((v - offset) / qty[i], 1));
			meter[i].scale.set(sz, sz);

			offset += qty[i];
		}

		return value = v;
	}
}
