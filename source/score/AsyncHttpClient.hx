package score;

import score.IHttpClient.HttpRequestInfo;
import sys.Http;
import sys.thread.Mutex;
import sys.thread.Thread;

class AsyncHttpClient implements IHttpClient
{
	private var lock:Mutex = new Mutex();

	public function new() {}

	public function get(inf:HttpRequestInfo)
	{
		Thread.create(() ->
		{
			lock.acquire();

			var req = new Http(inf.url);

			populateProperties(req, inf);

			req.onData = function(data:String)
			{
				inf.success(200, data);
				lock.release();
			};

			req.onError = function(e:String)
			{
				inf.error(e);
				lock.release();
			};

			req.request(false);
		});
	}

	public function post(inf:HttpRequestInfo)
	{
		Thread.create(() ->
		{
			lock.acquire();

			var req = new Http(inf.url);

			populateProperties(req, inf);

			req.setPostData(inf.body);

			req.onStatus = function(status:Int)
			{
				inf.success(status, null);
				lock.release();
			};

			req.onError = function(e:String)
			{
				inf.error(e);
				lock.release();
			}

			req.request(true);
		});
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
