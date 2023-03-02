package score;

import score.IHttpClient.HttpRequestInfo;

class HttpClient implements IHttpClient
{
	private var client:IHttpClient;

	public function new()
	{
		#if (target.threaded)
		client = new AsyncHttpClient();
		#else
		client = new BasicHttpClient();
		#end
	}

	public function get(req:HttpRequestInfo)
	{
		client.get(req);
	}

	public function post(req:HttpRequestInfo)
	{
		client.post(req);
	}
}
