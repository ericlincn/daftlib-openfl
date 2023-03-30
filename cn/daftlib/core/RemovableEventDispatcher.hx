package cn.daftlib.core;

import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;

/**
 * ...
 * @author eric.lin
 */
class RemovableEventDispatcher extends EventDispatcher implements IRemovableEventDispatcher implements IDestroyable
{
	public function new(target:IEventDispatcher = null) 
	{
		super(target);
	}
	public function destroy():Void 
	{
		this.removeEventListeners();
	}
	override public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void
	{
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		ListenerManager.registerEventListener(this, type, listener, useCapture);
	}
	override public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void
	{
		super.removeEventListener(type, listener, useCapture);
		ListenerManager.unregisterEventListener(this, type, listener, useCapture);
	}
	public function removeEventsForType(type:String):Void 
	{
		ListenerManager.removeEventsForType(this, type);
	}
	public function removeEventsForListener(listener:Dynamic->Void):Void 
	{
		ListenerManager.removeEventsForListener(this, listener);
	}
	public function removeEventListeners():Void 
	{
		ListenerManager.removeEventListeners(this);
	}
}