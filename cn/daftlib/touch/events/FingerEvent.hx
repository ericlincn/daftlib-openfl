package cn.daftlib.touch.events;

import openfl.events.Event;

/**
 * ...
 * @author eric.lin
 */
@:final class FingerEvent extends Event
{
	public static var FINGER_BEGIN:String = "fingerBegin";
	public static var FINGER_END:String = "fingerEnd";
	public static var FINGER_DOWN:String = "fingerDown";
	public static var FINGER_UP:String = "fingerUp";
	public static var FINGER_CLICK:String = "fingerClick";
	public static var FINGER_HOLD:String = "fingerHold";

	public var stageX:Float;
	public var stageY:Float;

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);
	}
}