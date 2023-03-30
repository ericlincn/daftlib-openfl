package cn.daftlib.media;

import cn.daftlib.core.RemovableEventDispatcher;
import cn.daftlib.data.IntDictionary;
import cn.daftlib.events.CuePointEvent;
import openfl.events.Event;
import openfl.events.IEventDispatcher;
import openfl.events.TimerEvent;
import openfl.utils.Timer;

/**
 * ...
 * @author eric.lin
 */
//[Event(name = "cue", type = "cn.daftlib.events.CuePointEvent")]
 
@:final class CuePointLocator extends RemovableEventDispatcher
{
	private var __media:IMedia;
	private var __timer:Timer;
	private var __refreshRate:Int;
	private var __cuepointsMap:IntDictionary<String> = new IntDictionary<String>();
	private var __cuepointsCount:Int = 0;
	
	public function new(media:IMedia, refreshRate:Int = 15) 
	{
		super(null);
		
		__media = media;
		__refreshRate = refreshRate;
	}
	override public function destroy():Void
	{
		__cuepointsMap = null;

		stopCheckingCuepoints();
		__timer = null;

		super.destroy();
	}
	public function addCuepoint(ms:Float):Void
	{
		if(__cuepointsMap == null)
			return;

		//__cuepointsMap[ms] = "false";
		__cuepointsMap.set(Std.int(ms), "false");
		__cuepointsCount++;

		if(__cuepointsCount == 1)
			startCheckingCuepoints();
	}
	private function startCheckingCuepoints():Void
	{
		if(__timer == null)
		{
			__timer = new Timer(1000 / __refreshRate);
			__timer.addEventListener(TimerEvent.TIMER, checkCuepoints);
			__timer.start();
		}
	}
	private function stopCheckingCuepoints():Void
	{
		if(__timer != null)
		{
			__timer.removeEventListener(TimerEvent.TIMER, checkCuepoints);
			__timer.stop();
		}
	}
	private function checkCuepoints(e:Event = null):Void
	{
		// Fix for destroy()
		if(__cuepointsMap == null)
			return;

		var targetKey:Null<Float> = null;

		for(key in __cuepointsMap.keys())
		{
			if(__media.playingTime >= key && Math.abs(__media.playingTime - key) < 1000)
			{
				if(targetKey == null)
					targetKey = key;
				else
					targetKey = Math.max(targetKey, key);
			}
		}

		if(targetKey == null)
			return;

		for(k in __cuepointsMap.keys())
		{
			if(k == targetKey)
			{
				//if(__cuepointsMap[k] == "false")
				if(__cuepointsMap.get(k) == "false")
				{
					//__cuepointsMap[k] = "true";
					__cuepointsMap.set(k, "true");

					var event:CuePointEvent = new CuePointEvent(CuePointEvent.CUE);
					event.time = k;
					this.dispatchEvent(event);
				}
			}
			else
				__cuepointsMap.set(k, "false");
		}
	}
}