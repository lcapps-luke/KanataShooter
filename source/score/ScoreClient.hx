package score;

import datetime.DateTime;
import flixel.FlxG;
import haxe.Json;
import haxe.crypto.Md5;

class ScoreClient {
	private static inline var ROOT:String = "https://score.lc-apps.co.uk/kanata";
	private static inline var PERIOD_DAYS:Int = 120;

	private static var client = new HttpClient();

	public static function getToken(callback:String->Void):Void {
		client.get({
			url: '$ROOT/token',
			headers: [],
			params: [],
			success: (code:Int, content:String) -> {
				callback(content);
			},
			error: (msg:String) -> {
				callback(null);
			}
		});
	}

	public static function submit(token:String, name:String, score:Int, callback:Bool->Void, itchUserId:String = null):Void {
		client.post({
			url: '$ROOT',
			headers: ["Content-Type" => "application/json"],
			params: [],
			body: Json.stringify({
				token: token,
				value: score,
				name: name,
				proof: Md5.encode(token + name),
				itchUserId: itchUserId
			}),
			success: (status:Int, content:String) -> {
				callback(status >= 200 && status <= 299);
			},
			error: (msg) -> {
				callback(false);
			}
		});
	}

	public static function listScores(callback:Array<Score>->Void):Void {
		client.get({
			url: '$ROOT',
			headers: [],
			params: ["from" => (DateTime.now() - Day(PERIOD_DAYS)).toString()],
			success: (status:Int, content:String) -> {
				try {
					var scores:Array<Score> = cast Json.parse(content);
					callback(scores);
				}
				catch (e) {
					FlxG.log.error(e);
					callback(null);
				}
			},
			error: (msg:String) -> {
				FlxG.log.error(msg);
				callback(null);
			}
		});
	}
}
