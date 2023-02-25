package enemy;

import enemy.Enemy;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class Spawner {
	private var group:FlxTypedGroup<Enemy>;
	private var callback:Enemy->Void;
	private var timer:Float = 0;

	private var phases:Array<Phase> = [
		{
			end: 5,
			opt: [getSingle],
			wei: [1]
		},
		{
			end: 30,
			opt: [getDouble, getSingle],
			wei: [1, 2]
		},
		{
			end: 60,
			opt: [getDouble, getSingle],
			wei: [1, 1]
		},
		{
			end: 100,
			opt: [getTriple, getDouble, getSingle],
			wei: [1, 2, 2]
		},
		{
			end: 150,
			opt: [getTriple, getDouble, getSingle],
			wei: [1, 1, 1]
		},
		{
			end: 220,
			opt: [getQuad, getTriple, getDouble, getSingle],
			wei: [1, 2, 2, 2]
		},
		{
			end: 300,
			opt: [getQuad, getTriple, getDouble, getSingle],
			wei: [1, 1, 1, 1]
		},
		{
			end: 400,
			opt: [getQuad, getTriple, getDouble],
			wei: [1, 1, 1]
		},
		{
			end: 500,
			opt: [getQuad, getTriple],
			wei: [1, 1]
		},
		{
			end: -1,
			opt: [getQuad],
			wei: [1]
		}
	];

	public function new(group:FlxTypedGroup<Enemy>, callback:Enemy->Void) {
		this.group = group;
		this.callback = callback;
	}

	public function update(s:Float, i:Int) {
		timer -= s;
		if (timer < 0) {
			var e = getNextEnemy(i);
			e.y = FlxG.random.float(0, FlxG.height - e.height);
			e.x = FlxG.width;
			e.velocity.set(-200);
			e.killCallback = callback;
			e.group = group;

			var minTime = Math.abs(e.velocity.x / e.width);
			timer = FlxG.random.float(minTime, minTime * 2);
		}
	}

	private function getNextEnemy(i:Int):Enemy {
		for (p in phases) {
			if (i < p.end || p.end < 0) {
				try {
					var createMethod = p.opt.length == 1 ? p.opt[0] : FlxG.random.getObject(p.opt, p.wei);
					return createMethod(group);
				}
				catch (e) {
					trace(e);
				}
			}
		}
		return getQuad(group);
	}

	private static inline function getSingle(group:FlxTypedGroup<Enemy>):Enemy {
		return group.recycle(SingleEnemy, SingleEnemy.new);
	}

	private static inline function getDouble(group:FlxTypedGroup<Enemy>):Enemy {
		return group.recycle(DoubleEnemy, DoubleEnemy.new);
	}

	private static inline function getTriple(group:FlxTypedGroup<Enemy>):Enemy {
		return group.recycle(TripleEnemy, TripleEnemy.new);
	}

	private static inline function getQuad(group:FlxTypedGroup<Enemy>):Enemy {
		return group.recycle(QuadEnemy, QuadEnemy.new);
	}
}

typedef Phase = {
	var end:Int;
	var opt:Array<FlxTypedGroup<Enemy>->Enemy>;
	var wei:Array<Float>;
}
