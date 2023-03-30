package cn.daftlib.touch.vo;

/**
 * ...
 * @author eric.lin
 */
@:final class TouchObject
{
	public var classID(get, null):Int;
	public var x(get, null):Float;
	public var y(get, null):Float;
	public var angle(get, null):Float;
	
	private var __classID:Int;
	private var __x:Float;
	private var __y:Float;
	private var __a:Float;

	public function new(_classID:Int, _x:Float, _y:Float, _angle:Float)
	{
		__classID = _classID;

		update(_x, _y, _angle);
	}
	public function update(_x:Float, _y:Float, _angle:Float):Void
	{
		__x = _x;
		__y = _y;
		__a = _angle;
	}
	private function get_classID():Int
	{
		return __classID;
	}
	private function get_x():Float
	{
		return __x;
	}
	private function get_y():Float
	{
		return __y;
	}
	private function get_angle():Float
	{
		return __a;
	}
	public function toString():String
	{
		var out:String = "";
		out += "TouchObject(";
		out += "classID: " + __classID;
		out += ", x: " + __x;
		out += ", y: " + __y;
		out += ", angle: " + __a;
		out += ")";

		return out;
	}
}