package firemode;

class QuadFireMode extends AbstractFireMode {
	private static inline var SHOT_OFFSET:Float = 0.05;
	private static inline var MOTION_TIME_INCR:Float = 3.14 * 2;

	private var even:Bool = true;

	function fire():Float {
		even ? fireA() : fireB();
		even = !even;

		return even ? 0.5 : SHOT_OFFSET;
	}

	function fireA() {
		makeHaloFunc(sinFunc, true);
		makeHaloFunc(cosFunc, false);
	}

	function fireB() {
		makeHalo(0, 0, true).velocity.rotateByDegrees(-10);
		makeHalo(0, 0, false).velocity.rotateByDegrees(10);
	}

	private function makeHaloFunc(func:Float->Float, sound:Bool) {
		var halo = makeHalo(0, 0, sound);
		halo.setMotionFunction(func, MOTION_TIME_INCR);
	}

	private function sinFunc(val:Float) {
		return Math.sin(val) * 40;
	}

	private function cosFunc(val:Float) {
		return Math.sin(val + Math.PI) * 40;
	}
}
