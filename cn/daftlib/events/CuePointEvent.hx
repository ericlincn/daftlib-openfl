package cn.daftlib.events;

import openfl.events.Event;

/**
 * ...
 * @author eric.lin
 */
@:final class CuePointEvent extends Event
{
	public static var CUE:String = "cue";

	public var time:Float;
	
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false) 
	{
		super(type, bubbles, cancelable);
	}
}