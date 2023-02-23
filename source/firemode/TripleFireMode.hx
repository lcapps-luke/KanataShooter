package firemode;

class TripleFireMode extends AbstractFireMode {
	private static inline var SHOT_OFFSET:Float = 0.05;
	private static inline var MOTION_TIME_INCR:Float = 3.14 * 2;
	private static inline var MOTION_FUNC_DIFF:Float = MOTION_TIME_INCR * SHOT_OFFSET + 3.14;

	private var phase:Int = 0;

	function fire():Float {
		if (phase == 0) {
			// sin
			makeHaloFunc(sinFunc);
			phase = 1;
			return SHOT_OFFSET;
		}
		else if (phase == 1) {
			// none
			makeHalo();
			phase = 2;
			return SHOT_OFFSET;
		}
		else {
			// cos
			makeHaloFunc(cosFunc);
			phase = 0;
			return 0.5;
		}
	}

	private function makeHaloFunc(func:Float->Float) {
		var halo = makeHalo();
		halo.setMotionFunction(func, MOTION_TIME_INCR);
	}

	private function sinFunc(val:Float) {
		return Math.sin(val) * 40;
	}

	private function cosFunc(val:Float) {
		return Math.sin(val + MOTION_FUNC_DIFF) * 40;
	}
}
