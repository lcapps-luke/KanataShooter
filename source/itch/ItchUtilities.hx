package itch;

#if html5
import js.Syntax;
#end

class ItchUtilities
{
	public static function getUser(callback:String->Int->Void)
	{
		var key = getApiKey();

		if (key == null)
		{
			return;
		}

		ItchClient.getMe(key, response ->
		{
			if (response.user != null)
			{
				callback(response.user.display_name, response.user.id);
			}
		});
	}

	private static function getApiKey():Null<String>
	{
		#if html5
		if (Syntax.code("typeof Itch !== 'undefined'"))
		{
			return Syntax.code("Itch.env.ITCHIO_API_KEY");
		}
		#end

		#if !android
		return Sys.getEnv("ITCHIO_API_KEY");
		#end

		return null;
	}
}
