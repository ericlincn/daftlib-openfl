package cn.daftlib.algorithm;

import cn.daftlib.display.DaftBitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;

/**
 * ...
 * @author eric.lin
 */
class ColourCentrum extends DaftBitmap
{
	private var __width:Int;
	private var __height:Int;
	
	public function new(width:Int, height:Int) 
	{
		super(null, PixelSnapping.AUTO, false);
		
		__width = width;
		__height = height;

		this.bitmapData = new BitmapData(__width, __height, false, 0x0);

		var j:Int = 0;
		var color:Int;
		while(j < __height)
		{
			var i:Int = 0;
			while(i < __width)
			{
				this.bitmapData.setPixel(i, j, (RD(i, j) << 16 | GR(i, j) << 8 | BL(i, j)));
				i++;
			}
			j++;
		}
	}
	private function RD(i:Int, j:Int):Int
	{
		return Std.int(_sq(Math.cos(Math.atan2(j - __height * .5, i - __width * .5) / 2)) * 255);
	}
	private function GR(i:Int, j:Int):Int
	{
		return Std.int(_sq(Math.cos(Math.atan2(j - __height * .5, i - __width * .5) / 2 - 2 * Math.acos(-1) / 3)) * 255);
	}
	private function BL(i:Int, j:Int):Int
	{
		return Std.int(_sq(Math.cos(Math.atan2(j - __height * .5, i - __width * .5) / 2 + 2 * Math.acos(-1) / 3)) * 255);
	}
	private function _sq(value:Float):Float
	{
		return value * value;
	}
}