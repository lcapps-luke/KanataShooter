package score;

typedef HttpRequestInfo =
{
	var url:String;
	var params:Map<String, String>;
	var headers:Map<String, String>;
	var ?body:String;
	var success:Int->String->Void;
	var error:String->Void;
}

interface IHttpClient
{
	public function get(req:HttpRequestInfo):Void;
	public function post(req:HttpRequestInfo):Void;
}
