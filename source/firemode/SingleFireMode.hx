package firemode;

class SingleFireMode extends AbstractFireMode {
	function fire():Float {
		makeHalo();
		return 0.5;
	}
}
