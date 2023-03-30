package cn.daftlib.events;

import openfl.events.Event;

/**
 * ...
 * @author eric.lin
 */
@:final class LoadEvent extends Event
{
	public static var START:String = "start";
	public static var PROGRESS:String = "progress";
	public static var COMPLETE:String = "complete";
	public static var ITEM_COMPLETE:String = "itemComplete";

	public var url:String;
	public var percent:Float;
	public var itemsLoaded:Int;
	public var itemsTotal:Int;
	
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false) 
	{
		super(type, bubbles, cancelable);
	}
}