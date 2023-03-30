package cn.daftlib.color;

/**
 * ...
 * @author eric.lin
 */
class RGB implements IColor
{
	public var value(get, set):Int;
	public var r(get, set):Int;
	public var g(get, set):Int;
	public var b(get, set):Int;
	
	private var _r:Int;
	private var _g:Int;
	private var _b:Int;
	
	public function new(r:Int = 0, g:Int = 0, b:Int = 0) 
	{
		set_r(r);
		set_g(g);
		set_b(b);
	}
	private function get_value():Int 
	{
		return _r << 16 | _g << 8 | _b;
	}
	private function set_value(value:Int):Int 
	{
		_r = value >> 16;
		_g = (value & 0x00ff00) >> 8;
		_b = value & 0x0000ff;
		
		return 0;
	}
	private function get_r():Int
	{
		return _r;
	}
	private function set_r(value:Int):Int
	{
		return _r = Std.int(Math.max(0, Math.min(255, value)));
	}
	private function get_g():Int
	{
		return _g;
	}
	private function set_g(value:Int):Int
	{
		return _g = Std.int(Math.max(0, Math.min(255, value)));
	}
	public function get_b():Int
	{
		return _b;
	}
	private function set_b(value:Int):Int
	{
		return _b = Std.int(Math.max(0, Math.min(255, value)));
	}
}