package cn.daftlib.core;
import openfl.events.IEventDispatcher;

/**
 * ...
 * @author eric.lin
 */

//using namespace arcane 

@:allow(cn.daftlib.core.IRemovableEventDispatcher)
@:final class ListenerManager
{
	private static var __dispatcherMap:Map<IEventDispatcher, Array<EventInfo>> = new Map<IEventDispatcher, Array<EventInfo>>();
	
	private static function registerEventListener(dispatcher:IEventDispatcher, type:String, listener:Dynamic -> Void, useCapture:Bool):Void
	{
		var eventInfoArr:Array<EventInfo> = __dispatcherMap[dispatcher];
		var newEventInfo:EventInfo = new EventInfo(type, listener, useCapture);
		var oldEventInfo:EventInfo;

		if(eventInfoArr != null)
		{
			var i:Int = eventInfoArr.length;
			while((i--)>0)
			{
				oldEventInfo = eventInfoArr[i];
				if(oldEventInfo.equals(newEventInfo))
					return;
			}
			eventInfoArr.push(newEventInfo);
		}
		else
		{
			__dispatcherMap[dispatcher] = [newEventInfo];
		}
	}
	private static function unregisterEventListener(dispatcher:IEventDispatcher, type:String, listener:Dynamic -> Void, useCapture:Bool):Void
	{
		var eventInfoArr:Array<EventInfo> = __dispatcherMap[dispatcher];
		var newEventInfo:EventInfo = new EventInfo(type, listener, useCapture);
		var oldEventInfo:EventInfo;

		if(eventInfoArr == null)
			return;

		var i:Int = eventInfoArr.length;
		while((i--)>0)
		{
			oldEventInfo = eventInfoArr[i];
			if(oldEventInfo.equals(newEventInfo))
				eventInfoArr.splice(i, 1);
		}

		if (eventInfoArr.length == 0)
			__dispatcherMap.remove(dispatcher);
	}
	private static function removeEventsForType(dispatcher:IEventDispatcher, type:String):Void
	{
		var eventInfoArr:Array<EventInfo> = __dispatcherMap[dispatcher];
		var oldEventInfo:EventInfo;

		if(eventInfoArr == null)
			return;

		var i:Int = eventInfoArr.length;
		while((i--)>0)
		{
			oldEventInfo = eventInfoArr[i];
			if(oldEventInfo.type == type)
			{
				eventInfoArr.splice(i, 1);
				dispatcher.removeEventListener(oldEventInfo.type, oldEventInfo.listener, oldEventInfo.useCapture);
			}
		}

		if(eventInfoArr.length == 0)
			__dispatcherMap.remove(dispatcher);
	}
	private static function removeEventsForListener(dispatcher:IEventDispatcher, listener:Dynamic -> Void):Void
	{
		var eventInfoArr:Array<EventInfo> = __dispatcherMap[dispatcher];
		var oldEventInfo:EventInfo;

		if(eventInfoArr == null)
			return;

		var i:Int = eventInfoArr.length;
		while((i--)>0)
		{
			oldEventInfo = eventInfoArr[i];
			if(oldEventInfo.listener == listener)
			{
				eventInfoArr.splice(i, 1);
				dispatcher.removeEventListener(oldEventInfo.type, oldEventInfo.listener, oldEventInfo.useCapture);
			}
		}

		if(eventInfoArr.length == 0)
			__dispatcherMap.remove(dispatcher);
	}
	private static function removeEventListeners(dispatcher:IEventDispatcher):Void
	{
		var eventInfoArr:Array<EventInfo> = __dispatcherMap[dispatcher];
		var oldEventInfo:EventInfo;

		if(eventInfoArr == null)
			return;

		var i:Int = eventInfoArr.length;
		while((i--)>0)
		{
			oldEventInfo = eventInfoArr.splice(i, 1)[0];
			dispatcher.removeEventListener(oldEventInfo.type, oldEventInfo.listener, oldEventInfo.useCapture);
		}

		__dispatcherMap.remove(dispatcher);
	}
	public static function printEventTypeList(dispatcher:IEventDispatcher):String
	{
		var eventInfoArr:Array<EventInfo> = __dispatcherMap[dispatcher];
		var oldEventInfo:EventInfo;

		if(eventInfoArr == null)
			return null;

		var outputStr:String = dispatcher + " --Event type list-- " + "\n";
		var i:Int = eventInfoArr.length;
		while((i--)>0)
		{
			oldEventInfo = eventInfoArr[i];
			outputStr += "	EventType:" + oldEventInfo.type;

			var fix:String = "";
			if(i != 0)
				fix = "\n";
			outputStr += fix;
		}
		return outputStr;

	}
}

private class EventInfo
{
	public var type:String;
	public var listener:Dynamic -> Void;
	public var useCapture:Bool;

	public function new(type:String, listener:Dynamic -> Void, useCapture:Bool)
	{
		this.type = type;
		this.listener = listener;
		this.useCapture = useCapture;
	}
	public function equals(eventInfo:EventInfo):Bool
	{
		return this.type == eventInfo.type && this.listener == eventInfo.listener && this.useCapture == eventInfo.useCapture;
	}
}