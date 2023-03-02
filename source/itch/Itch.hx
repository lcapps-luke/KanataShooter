package itch;

#if js
extern class Itch
{
	public static var env:Env;
}

typedef Env =
{
	var ITCHIO_API_KEY:String;
}
#end
