package cn.daftlib.time;

import cn.daftlib.core.RemovableEventDispatcher;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.IEventDispatcher;

/**
 * ...
 * @author eric.lin
 */
//[Event(name = "complete", type = "flash.events.Event")]

@:final class FrameThread extends RemovableEventDispatcher
{
	private var __methods:Array<Void -> Void>;
	private var __currentIndex:Int = 0;
	private var __intervalFrame:IntervalFrame;
	
	public function new(methods:Array<Void -> Void>, interval:Int = 1) 
	{
		super(null);
		
		interval = Std.int(Math.max(1, interval));

		if(methods == null || methods.length <= 1)
			throw new Error('Argument $methods should be valid.');

		__methods = methods;
		__intervalFrame = new IntervalFrame();
		__intervalFrame.addEventListener(applyMethods, interval);
	}
	override public function destroy():Void
	{
		__intervalFrame.removeEventListener(applyMethods);
		__intervalFrame.destroy();
		__intervalFrame = null;

		__methods = null;

		super.destroy();
	}
	private function applyMethods():Void
	{
		//__methods[__currentIndex].apply();
		Reflect.callMethod(null, __methods[__currentIndex], null);
		__currentIndex++;

		if(__currentIndex >= __methods.length)
		{
			__intervalFrame.removeEventListener(applyMethods);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}