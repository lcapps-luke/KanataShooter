package firemode;

import flixel.FlxG;

class SingleFireMode extends AbstractFireMode {
	function fire():Float {
		makeHalo();
		FlxG.sound.play(AssetPaths.shoot__wav, 0.6);

		return 0.5;
	}
}
