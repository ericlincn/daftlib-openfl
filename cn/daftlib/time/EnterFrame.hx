package cn.daftlib.time;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author eric.lin
 */
@:final class EnterFrame
{
	public static function addEventListener(listener:Dynamic -> Void):Void
	{
		Lib.current.addEventListener(Event.ENTER_FRAME, listener, false, 0, false);
	}
	public static function removeEventListener(listener:Dynamic -> Void):Void
	{
		Lib.current.removeEventListener(Event.ENTER_FRAME, listener, false);
	}
}