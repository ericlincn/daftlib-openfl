package cn.daftlib.utils;

/**
 * ...
 * @author eric.lin
 */
@:final class BitUtil
{
	public static function getBitN(value:Int, n:Int):Int
	{
		return (value >> (n - 1)) & 1;
	}
	public static function setBitN1(value:Int, n:Int):Int
	{
		return value | (1 << (n - 1));
	}
	public static function setBitN0(value:Int, n:Int):Int
	{
		return value & ~(1 << (n - 1));
	}

	/**
	 * 是否符号相反
	 * @param a
	 * @param b
	 * @return 
	 */		
	public static function oppositeSigns(a:Int, b:Int):Bool
	{
		return (a ^ b) < 0;
	}
	/**
	 * 是否为奇数
	 * @param value
	 * @return
	 */
	public static function isOdd(value:Int):Bool
	{
		return (value & 1) == 1;
	}

	/**
	 * 取绝对值
	 * @param value
	 * @return
	 */
	public static function abs(value:Int):Int
	{
		return (value ^ (value >> 31)) - (value >> 31);
	}

	public static function max(a:Int, b:Int):Int
	{
		return a ^ ((a ^ b) & -(a < b ? 1 : 0));
	}
	public static function min(a:Int, b:Int):Int
	{
		return b ^ ((a ^ b) & -(a < b ? 1 : 0));
	}

	/**
	 * 取平均值
	 * @param a
	 * @param b
	 * @return
	 * 如果用 (x+y)/2 求平均值，可能产生溢出
	 */
	public static function average(a:Int, b:Int):Int
	{
		return (a & b) + ((a ^ b) >> 1);
	}

	/**
	 * 是否为2的幂
	 * @param x
	 * @return
	 */
	public static function isPower2(value:Int):Bool
	{
		return ((value & (value - 1)) == 0) && (value != 0);
	}

	/**
	 * 乘法 value * 2
	 * @param value
	 * @return
	 */
	public static function mul2(value:Int):Int
	{
		return value << 1;
	}

	/**
	 * 除法 value / 2
	 * @param value
	 * @return
	 */
	public static function div2(value:Int):Int
	{
		return value >> 1;
	}

	/**
	 * 取模 value % 2
	 * @param value
	 * @return
	 */
	public static function mod2(value:Int):Int
	{
		return value & 1;
	}

	/**
	 * 对2^n取模
	 * @param value
	 * @param power
	 * @return
	 * value % (2^power)
	 */
	public static function mod2exp(value:Int, power:Int):Int
	{
		return value & (2 ^ power - 1);
	}

	/**
	 * 对2^n做乘法
	 * @param value
	 * @param power
	 * @return
	 * value * (2 ^ power)
	 */
	public static function mul2exp(value:Int, power:Int):Int
	{
		return value << power;
	}
	/**
	 * 对2^n做除法
	 * @param value
	 * @param power
	 * @return
	 * value / (2 ^ power)
	 */
	public static function div2exp(value:Int, power:Int):Int
	{
		return value >> power;
	}
}