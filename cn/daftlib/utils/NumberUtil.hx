package cn.daftlib.utils;

@:final class NumberUtil
{
	inline public static function abs(x:Float):Float
	{
		return (x < 0) ? ( -x) : x;
	}
	inline public static function min(x:Float, y:Float):Float
	{
		return (x < y) ? x : y;
	}
	inline public static function max(x:Float, y:Float):Float
	{
		return (x > y) ? x : y;
	}
	inline public static function floor(n:Float):Int
	{
		var ni:Int = Std.int(n);
		return (n < 0 && n != ni) ? ni - 1 : ni;
	}
	inline public static function round(n:Float):Int
	{
		var ni = n < 0 ? n + .5 == (Std.int(n) | 0) ? n : n - .5 : n + .5;
		return Std.int(ni);
	}
	inline public static function ceil(n:Float):Int
	{
		var ni:Int = Std.int(n);
		return (n >= 0 && n != ni) ? ni + 1 : ni;
	}
	
	public static function getUnique():Float
	{
		return Date.now().getTime();
	}
	
	/**
	 * 取得小数部分
	 * @param value
	 * @return 
	 */		
	public static function getDecimal(value:Float):Float
	{
		if(value < 1)
			return value;
		
		var arr:Array<String> = Std.string(value).split(".");
		if (arr[1] != null)
			return Std.parseFloat("0." + arr[1]);
		
		return 0;
	}
	
	// inline field: http://haxe.org/manual/class-field-inline.html
	
	/**
	 * 将目标数值限定于某个范围内，大于最大值等于最大值，小于最小值等于最小值
	 * @param value
	 * @param min
	 * @param max
	 * @return
	 */
	inline public static function clamp(value:Float, min:Float, max:Float):Float
	{
		return NumberUtil.min(max, NumberUtil.max(value, min));
	}
	
	/**
	 * 取得百分比
	 * @param value
	 * @param min
	 * @param max
	 * @return
	 */
	inline public static function getPercent(value:Float, min:Float, max:Float):Float
	{
		return (value - min) / (max - min);
	}
	
	/**
	 * 按位数取得小数
	 * @param value
	 * @param place
	 * @return
	 * @example
	 * <code>
	 * trace(NumberUtil.roundDecimalToPlace(3.14159, 2)); // Traces 3.14
	 * trace(NumberUtil.roundDecimalToPlace(3.14159, 3)); // Traces 3.142
	 * </code>
	 * 
	 * inline flash faster than js, no inline js faster 2x than flash
	 */
	inline public static function roundDecimalToPlace(value:Float, place:Int):Float
	{
		var p:Float = Math.pow(10, place);
		return NumberUtil.round(value * p) / p;
	}

	/**
	 * 在某个范围内取随机数
	 * @param min
	 * @param max
	 * @return
	 * 
	 * inline flash faster 2x than js, no inline js faster 2x than flash
	 */
	inline public static function randomInRange(min:Float, max:Float):Float
	{
		return min + (Math.random() * (max - min));
	}
	
	/**
	 * 随机布尔值
	 * @return
	 * 
	 * inline flash faster 2x than js, no inline js faster 2x than flash
	 */
	inline public static function randomBoolean():Bool
	{
		return Math.random() < 0.5;
	}
	
	/**
	 * 随机正负数
	 * @return
	 * 
	 * inline flash faster than js, no inline js faster 2x than flash
	 */
	inline public static function randomWave():Int
	{
		return NumberUtil.floor(Math.random() * 2) * 2 - 1;
	}
	
	/**
	 * 提取正负号
	 * @param value
	 * @return 
	 * 
	 * inline flash same as js, no inline js faster than flash
	 */		
	inline public static function extractPlusMinus(value:Float):Int
	{
		if (value == 0)
			return 0;
		
		return Std.int(value/NumberUtil.abs(value));
	}
}
