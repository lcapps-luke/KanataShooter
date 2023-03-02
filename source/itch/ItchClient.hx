package itch;

import haxe.Json;
import score.HttpClient;

class ItchClient
{
	private static var client = new HttpClient();

	public static function getMe(key:String, callback:UserResponse->Void)
	{
		client.get({
			url: "https://itch.io/api/1/jwt/me",
			headers: ["Authorization" => key],
			params: [],
			success: (status:Int, body:String) ->
			{
				callback(Json.parse(body));
			},
			error: (msg) -> {}
		});
	}
}

typedef UserResponse =
{
	var ?user:User;
	var ?errors:Array<String>;
}

typedef User =
{
	var display_name:String;
	var id:Int;
}
