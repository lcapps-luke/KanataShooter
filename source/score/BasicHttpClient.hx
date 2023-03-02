package score;

import haxe.Http;
import score.IHttpClient.HttpRequestInfo;

class BasicHttpClient implements IHttpClient
{
	public function new() {}

	public function get(inf:HttpRequestInfo)
	{
		var req = new Http(inf.url);
		#if html5
		req.async = true;
		#end

		populateProperties(req, inf);

		req.onData = function(data:String)
		{
			inf.success(200, data);
		};
		req.onError = inf.error;

		req.request(false);
	}

	public function post(inf:HttpRequestInfo)
	{
		var req = new Http(inf.url);
		#if html5
		req.async = true;
		#end

		populateProperties(req, inf);

		req.setPostData(inf.body);

		req.onStatus = function(status:Int)
		{
			inf.success(status, null);
		};

		req.onError = inf.error;

		req.request(true);
	}

	private inline function populateProperties(req:Http, inf:HttpRequestInfo)
	{
		for (kv in inf.headers.keyValueIterator())
		{
			req.addHeader(kv.key, kv.value);
		}

		for (kv in inf.params.keyValueIterator())
		{
			req.addParameter(kv.key, kv.value);
		}
	}
}
