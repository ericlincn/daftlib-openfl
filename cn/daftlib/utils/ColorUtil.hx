package cn.daftlib.utils;

/**
 * ...
 * @author eric.lin
 */
@:final class ColorUtil
{
	public static function toRGB(argb:Int):Int
	{
		var rgb:Int = 0;
		rgb = (argb & 0xFFFFFF);
		return rgb;
	}
	public static function toARGB(rgb:Int, alpha:Float = 1):Int
	{
		var a:Int = Std.int(alpha * 255);
		//a = color32 >> 24;
		var r:Int = rgb >> 16 & 0xFF ;
		var g:Int = rgb >> 8 & 0xFF ;
		var b:Int = rgb & 0xFF ;

		return a << 24 | r << 16 | g << 8 | b;
	}
	public static function getRandomColor():Int
	{
		return Std.parseInt("0x" + StringTools.hex(Std.int(Math.random() * 0xFFFFFF), 6));
	}
	public static function getGray(gray:Int):Int
	{
		gray = Std.int(Math.max(0, Math.min(255, gray)));
		
		var r:Int;
		var g:Int;
		var b:Int;
		r = g = b = gray & 0xFF;
		
		return r << 16 | g << 8 | b;
	}
	public static function isDarkColor(rgb:Int):Bool
	{
		var r:Int = rgb >> 16 & 0xFF;
		var g:Int = rgb >> 8  & 0xFF;
		var b:Int = rgb & 0xFF;
		var perceivedLuminosity = (0.299 * r + 0.587 * g + 0.114 * b);
		return perceivedLuminosity < 70;
	}
	public static function getAverageColor(colors:Array<Int>):Int
	{
		var r:Float = 0;
		var g:Float = 0;
		var b:Float = 0;
		var l:Int = colors.length;
		var i:Int = 0;
		while (i < l)
		{
			r += colors[i] >> 16;
			g += (colors[i] & 0x00ff00) >> 8;
			b += colors[i] & 0x0000ff;
			
			i++;
		}
		r /= l;
		g /= l;
		b /= l;
		
		return Std.int(r) << 16 | Std.int(g) << 8 | Std.int(b);
	}
}