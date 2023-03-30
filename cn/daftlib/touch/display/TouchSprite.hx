package cn.daftlib.touch.display;

import cn.daftlib.display.DaftSprite;
import cn.daftlib.time.EnterFrame;
import cn.daftlib.touch.events.FingerEvent;
import cn.daftlib.touch.interfaces.ITouchCursorHandler;
import cn.daftlib.touch.vo.TouchCursor;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author eric.lin
 */
/*[Event(name = "fingerBegin", type = "cn.daftlib.touch.events.FingerEvent")]
[Event(name = "fingerEnd", type = "cn.daftlib.touch.events.FingerEvent")]
[Event(name = "fingerDown", type = "cn.daftlib.touch.events.FingerEvent")]
[Event(name = "fingerUp", type = "cn.daftlib.touch.events.FingerEvent")]
[Event(name = "fingerClick", type = "cn.daftlib.touch.events.FingerEvent")]
[Event(name = "fingerHold", type = "cn.daftlib.touch.events.FingerEvent")]*/

class TouchSprite extends DaftSprite implements ITouchCursorHandler
{
	public var touchEnabled(get, set):Bool;
	public var bubbleEnabled(get, null):Bool;
	
	private var HOLD_DELAY:Int = 300;

	//protected
	private var NONE:String = "none";
	//protected
	private var __bubbleEnabled:Bool = false;

	// works just like mouseEnabled
	private var __touchEnabled:Bool = true;

	//protected
	private var __state:String = "none";
	//protected
	private var __touchCursorCloneArr:Array<TouchCursor> = [];

	// Hold gesture related
	private var __holdTime:Int;
	private var __gestureSequence:Array<String> = [];
	
	public function new() 
	{
		super();
	}
	override public function destroy():Void
	{
		EnterFrame.removeEventListener(onRenderTick);
		EnterFrame.removeEventListener(countHoldTime);

		super.destroy();

		__touchCursorCloneArr = null;
		__gestureSequence = null;
	}
	private function set_touchEnabled(value:Bool):Bool
	{
		return __touchEnabled = value;
	}
	private function get_touchEnabled():Bool
	{
		return __touchEnabled;
	}
	private function get_bubbleEnabled():Bool
	{
		return __bubbleEnabled;
	}
	public function addTouchCursor(sessionID:Int):Void
	{
		var tc:TouchCursor;
		var clone:TouchCursor;
		var i:Int = 0;
		while(i < __touchCursorCloneArr.length)
		{
			if(__touchCursorCloneArr[i].sessionID == sessionID)
				return;

			i++;
		}

		tc = TouchListener.getTouchCursor(sessionID);
		clone = getClone(tc);

		__touchCursorCloneArr.push(clone);

		if(__touchCursorCloneArr.length == 1)
		{
			EnterFrame.addEventListener(onRenderTick);
			handleTouchBegin(clone.x, clone.y);
		}

		__updateState();

		handleTouchDown(clone.x, clone.y);
	}
	private function checkTouchCursorAlive():Void
	{
		var tc:TouchCursor;
		var clone:TouchCursor=null;
		var i:Int = __touchCursorCloneArr.length;
		while((i--)>0)
		{
			clone = __touchCursorCloneArr[i];
			tc = TouchListener.getTouchCursor(clone.sessionID);

			if(tc == null)
			{
				__touchCursorCloneArr.splice(i, 1);

				__updateState();

				handleTouchUp(clone.x, clone.y);
			}
			else
			{
				clone.update(tc.x, tc.y);
			}
		}

		if(__touchCursorCloneArr != null && __touchCursorCloneArr.length == 0) // destroy bugfix
		{
			EnterFrame.removeEventListener(onRenderTick);
			handleTouchEnd(clone.x, clone.y);
		}
	}
	private function __updateState():Void
	{

	}
	private function __onTouchEnd():Void
	{

	}
	private function __onRenderTick():Void
	{
		
	}
	private function stopCountHoldTime(eventType:String, checkExist:Bool = false):Void
	{
		EnterFrame.removeEventListener(countHoldTime);

		if(checkExist == true)
		{
			if(__gestureSequence.indexOf(eventType) < 0)
				__gestureSequence.push(eventType);
		}
		else
			__gestureSequence.push(eventType);
	}
	/**
	 * dispatch gesture events
	 */
	private function handleTouchBegin(stageX:Float, stageY:Float):Void
	{
		var event:FingerEvent = new FingerEvent(FingerEvent.FINGER_BEGIN);
		event.stageX = stageX;
		event.stageY = stageY;
		this.dispatchEvent(event);
	}
	private function handleTouchEnd(stageX:Float, stageY:Float):Void
	{
		var event:FingerEvent = new FingerEvent(FingerEvent.FINGER_END);
		event.stageX = stageX;
		event.stageY = stageY;
		this.dispatchEvent(event);

		__onTouchEnd();
	}
	private function handleTouchDown(stageX:Float, stageY:Float):Void
	{
		var event:FingerEvent = new FingerEvent(FingerEvent.FINGER_DOWN);
		event.stageX = stageX;
		event.stageY = stageY;
		this.dispatchEvent(event);

		__holdTime = Lib.getTimer();
		EnterFrame.addEventListener(countHoldTime);
		__gestureSequence.push(FingerEvent.FINGER_DOWN);
	}
	private function countHoldTime(e:Event):Void
	{
		if(destroyed() == true) // destroy bugfix
			return;

		if(__touchCursorCloneArr.length < 1)
			return;

		if((Lib.getTimer() - __holdTime) >= HOLD_DELAY)
		{
			var event:FingerEvent = new FingerEvent(FingerEvent.FINGER_HOLD);
			event.stageX = __touchCursorCloneArr[0].x;
			event.stageY = __touchCursorCloneArr[0].y;
			if(__touchEnabled == true)
			this.dispatchEvent(event);

			stopCountHoldTime(event.type);
		}
	}
	private function checkClickGestures(stageX:Float, stageY:Float):Void
	{
		var sequeceStr:String = __gestureSequence.join("");

		if(sequeceStr == FingerEvent.FINGER_DOWN + FingerEvent.FINGER_UP)
		{
			var event:FingerEvent = new FingerEvent(FingerEvent.FINGER_CLICK);
			event.stageX = stageX;
			event.stageY = stageY;
			if(__touchEnabled == true)
			this.dispatchEvent(event);
		}
	}
	private function handleTouchUp(stageX:Float, stageY:Float):Void
	{
		var event:FingerEvent = new FingerEvent(FingerEvent.FINGER_UP);
		event.stageX = stageX;
		event.stageY = stageY;
		if(__touchEnabled == true)
		this.dispatchEvent(event);

		stopCountHoldTime(event.type);

		checkClickGestures(stageX, stageY);

		__gestureSequence = [];
	}

	/**
	 * on render
	 */
	private function onRenderTick(e:Event):Void
	{
		if(destroyed() == true) // destroy bugfix
			return;

		checkTouchCursorAlive();
		
		__onRenderTick();
	}

	/**
	 * utils
	 */
	private function getClone(target:TouchCursor):TouchCursor
	{
		return new TouchCursor(target.sessionID, target.x, target.y);
	}
	private function isListening(eventType:String):Bool
	{
		return this.hasEventListener(eventType);
	}
	private function destroyed():Bool
	{
		return __touchCursorCloneArr == null;
	}
}