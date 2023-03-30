package cn.daftlib.color;

/**
 * ...
 * @author eric.lin
 */
@:final class RGB32 extends RGB
{
	public var alpha(get, set):Int;
	
	private var _a:Int;
	
	public function new(r:Int=0, g:Int=0, b:Int=0, a:Int=255) 
	{
		super(r, g, b);
		
		set_alpha(a);
	}
	override private function get_value():Int
	{
		return _a << 24 | r << 16 | g << 8 | b;
	}
	override private function set_value(value32:Int):Int
	{
		_a = value32 >> 24;
		_a = _a < 0 ? (256 + _a) : _a;
		r = value32 >> 16 & 0xff;
		g = value32 >> 8 & 0xff;
		b = value32 & 0xff;
		
		return 0;
	}
	private function get_alpha():Int
	{
		return _a;
	}
	private function set_alpha(value:Int):Int
	{
		return _a = Std.int(Math.max(0, Math.min(255, value)));
	}
}