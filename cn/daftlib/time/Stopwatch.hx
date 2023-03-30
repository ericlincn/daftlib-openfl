package cn.daftlib.time;
import openfl.Lib;

/**
 * ...
 * @author eric.lin
 */
@:final class Stopwatch
{
	public static var time(get, null):Int;
	
	private static var __startTime:Int = 0;

	public static function start():Void
	{
		__startTime = Lib.getTimer();
	}
	private static function get_time():Int
	{
		return Lib.getTimer() - __startTime;
	}
}