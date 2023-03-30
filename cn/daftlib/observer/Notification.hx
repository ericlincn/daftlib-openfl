package cn.daftlib.observer;

/**
 * ...
 * @author eric.lin
 */
@:final class Notification implements INotification
{
	public var name(get, null):String;
	public var body(get, null):Dynamic;
	
	private var __name:String;
	private var __body:Dynamic;

	public function new(name:String, body:Dynamic)
	{
		__name = name;
		__body = body;
	}
	private function get_name():String
	{
		return __name;
	}
	private function get_body():Dynamic
	{
		return __body;
	}
}