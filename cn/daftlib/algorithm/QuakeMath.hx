package cn.daftlib.algorithm;
import openfl.Memory;

/**
 * ...
 * @author eric.lin
 */
class QuakeMath
{
	/**
	 * sqrt and invsqrt from quake sources
	 * @param x
	 * @return
	 */
	public static inline function sqrt(x:Float):Float
	{
		var half = 0.5 * x;
		Memory.setFloat(0,x);
		var i = Memory.getI32(0);
		i = 0x5f3759df - (i>>1);
		Memory.setI32(0,i);
		x = Memory.getFloat(0);
		x = x * (1.5 - half*x*x);
		return 1/ x;
	}
	
	public static inline function invSqrt(x:Float):Float 
	{
		var half = 0.5 * x;
		Memory.setFloat(0,x);
		var i = Memory.getI32(0);
		i = 0x5f375a86 - (i>>1);
		Memory.setI32(0,i);
		x = Memory.getFloat(0);
		x = x * (1.5 - half*x*x);
		return x;
	}
}