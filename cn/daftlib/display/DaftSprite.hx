package cn.daftlib.display;

import cn.daftlib.core.IDestroyable;
import cn.daftlib.core.IRemovableEventDispatcher;
import cn.daftlib.core.ListenerManager;
import openfl.display.Sprite;

/**
 * ...
 * @author eric.lin
 */
class DaftSprite extends Sprite implements IRemovableEventDispatcher implements IDestroyable
{
	public function new() 
	{
		super();

		this.mouseChildren = this.mouseEnabled = false;
	}
	public function destroy():Void 
	{
		this.removeEventListeners();

		if(this.parent != null)
			this.parent.removeChild(this);
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
	#if !flash
	override function set_x(value:Float):Float
	{
		return super.x = Std.int(value);
	}
	override function set_y(value:Float):Float
	{
		return super.y = Std.int(value);
	}
	#else
	@:setter(x) function set_x(value:Float):Void
	{
		super.x = Std.int(value);
	}
	@:setter(y) function set_y(value:Float):Void
	{
		super.y = Std.int(value);
	}
	#end
}