package firemode;

import flixel.FlxG;

class DoubleFireMode extends AbstractFireMode {
	private var even:Bool = true;
	private var secondTimeout:Float = -1;

	function fire():Float {
		makeHaloOffset();

		secondTimeout = 0.12;
		return 0.5;
	}

	override function update(s:Float, x:Float, y:Float, firing:Bool) {
		super.update(s, x, y, firing);

		if (secondTimeout > 0) {
			secondTimeout -= s;

			if (secondTimeout <= 0 && firing) {
				makeHaloOffset();
			}
		}
	}

	private function makeHaloOffset() {
		makeHalo(0, even ? -20 : 20);
		FlxG.sound.play(AssetPaths.shoot__wav, 0.6);
		even = !even;
	}
}
