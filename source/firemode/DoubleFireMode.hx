package firemode;

class DoubleFireMode extends AbstractFireMode {
	private var even:Bool = true;
	private var secondTimeout:Float = -1;

	function fire():Float {
		makeHaloOffset();
		return even ? 0.5 : 0.12;
	}

	private function makeHaloOffset() {
		makeHalo(0, even ? -20 : 20);
		even = !even;
	}
}
