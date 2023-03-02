package enemy;

import enemy.Enemy;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;

class Spawner {
	private var group:FlxTypedGroup<Enemy>;
	private var bossGroup:FlxSpriteGroup;
	private var callback:Enemy->Void;
	private var timer:Float = 0;

	public var boss:Enemy;
	public var bossSpawned(default, null) = false;

	private var phases:Array<Phase> = [
		{
			end: 2,
			opt: [getSingle],
			wei: [1]
		},
		{
			end: 8,
			opt: [getDouble, getSingle],
			wei: [1, 2]
		},
		{
			end: 15,
			opt: [getDouble, getSingle],
			wei: [1, 1]
		},
		{
			end: 30,
			opt: [getTriple, getDouble, getSingle],
			wei: [1, 2, 2]
		},
		{
			end: 50,
			opt: [getTriple, getDouble, getSingle],
			wei: [1, 1, 1]
		},
		{
			end: 80,
			opt: [getQuad, getTriple, getDouble, getSingle],
			wei: [1, 2, 2, 2]
		},
		{
			end: 100,
			opt: [getQuad, getTriple, getDouble, getSingle],
			wei: [1, 1, 1, 1]
		},
		{
			end: 120,
			opt: [getQuad, getTriple, getDouble],
			wei: [1, 1, 1]
		},
		{
			end: 150,
			opt: [getQuad, getTriple],
			wei: [1, 1]
		}
	];

	public function new(group:FlxTypedGroup<Enemy>, callback:Enemy->Void, bossGroup:FlxSpriteGroup) {
		this.group = group;
		this.callback = callback;
		this.bossGroup = bossGroup;
	}

	public function getBossHealth():Float {
		return boss.health / BossEnemy.MAX_HEALTH;
	}

	public function update(s:Float, i:Int) {
		if (bossSpawned) {
			return;
		}

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
					var e = createMethod(group);

					e.y = FlxG.random.float(0, FlxG.height - e.height);
					e.x = FlxG.width;
					e.velocity.set(-200);
					e.killCallback = callback;
					e.group = group;
					return e;
				}
				catch (e) {
					FlxG.log.error(e);
				}
			}
		}

		boss = getBoss(group, bossGroup);
		boss.killCallback = callback;
		boss.group = group;
		bossSpawned = true;
		return boss;
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

	private static inline function getBoss(group:FlxTypedGroup<Enemy>, bossGroup:FlxSpriteGroup):Enemy {
		return group.recycle(BossEnemy, () -> new BossEnemy(bossGroup));
	}
}

typedef Phase = {
	var end:Int;
	var opt:Array<FlxTypedGroup<Enemy>->Enemy>;
	var wei:Array<Float>;
}
