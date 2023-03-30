package cn.daftlib.touch.vo;

/**
 * ...
 * @author eric.lin
 */
@:final class TouchCursor
{
	public var sessionID(get, null):Int;
	public var x(get, null):Float;
	public var y(get, null):Float;
	public var startX(get, null):Float;
	public var startY(get, null):Float;
	public var offsetX(get, null):Float;
	public var offsetY(get, null):Float;
	public var speedX(get, null):Float;
	public var speedY(get, null):Float;
	
	private var __sessionID:Int;
	private var __x:Float;
	private var __y:Float;
	
	private var __startX:Float;
	private var __startY:Float;
	private var __speedX:Float = 0;
	private var __speedY:Float = 0;
	
	public function new(_sessionID:Int, _x:Float, _y:Float)
	{
		__sessionID = _sessionID;
		__startX = _x;
		__startY = _y;
		__x = _x;
		__y = _y;
	}
	private function get_sessionID():Int
	{
		return __sessionID;
	}
	private function get_x():Float
	{
		return __x;
	}
	private function get_y():Float
	{
		return __y;
	}
	private function get_startX():Float
	{
		return __startX;
	}
	private function get_startY():Float
	{
		return __startY;
	}
	private function get_offsetX():Float
	{
		return __x - __startX;
	}
	private function get_offsetY():Float
	{
		return __y - __startY;
	}
	private function get_speedX():Float
	{
		return __speedX;
	}
	private function get_speedY():Float
	{
		return __speedY;
	}
	public function update(_x:Float, _y:Float):Void
	{
		__speedX = _x - __x;
		__speedY = _y - __y;
		
		__x = _x;
		__y = _y;
	}
	public function toString():String
	{
		var out:String = "";
		out += "TouchCursor(";
		out += "sessionID: " + __sessionID;
		out += ", x: " + __x;
		out += ", y: " + __y;
		out += ")";
		
		return out;
	}
}