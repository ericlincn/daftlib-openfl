package cn.daftlib.events;

import openfl.events.Event;

/**
 * ...
 * @author eric.lin
 */
@:final class VideoEvent extends Event
{
	public static var START:String = "start";
	public static var STOP:String = "stop";
	public static var META_DATA:String = "metaData";
	public static var BUFFER_FULL:String = "bufferFull";
	public static var BUFFER_EMPTY:String = "bufferEmpty";

	public var duration:Float;
	public var framerate:Int;
	public var width:Float;
	public var height:Float;
	
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false) 
	{
		super(type, bubbles, cancelable);
	}
}