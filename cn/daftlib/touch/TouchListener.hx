package cn.daftlib.touch;

import cn.daftlib.data.IntDictionary;
#if js
import cn.daftlib.platform.JavaScript;
#end
import cn.daftlib.touch.interfaces.ITouchCursorHandler;
import cn.daftlib.touch.interfaces.ITouchListener;
import cn.daftlib.touch.utils.TouchUtil;
import cn.daftlib.touch.vo.TouchCursor;
import cn.daftlib.touch.vo.TouchObject;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.geom.Point;

/**
 * ...
 * @author eric.lin
 */
@:final class TouchListener implements ITouchListener
{
	private var __stage:Stage;
		
	private static var __touchCursorMap:IntDictionary<TouchCursor> = new IntDictionary<TouchCursor>();
	private static var __touchObjectMap:IntDictionary<TouchObject> = new IntDictionary<TouchObject>();
	
	public function new(stage:Stage)
	{
		__stage = stage;
		
		#if js
		JavaScript.fixCanvasTouchEnd(touchesAliveHandler);
		#end
	}
	public static function getTouchCursor(sessionID:Int):TouchCursor
	{
		if(__touchCursorMap.get(sessionID) != null)
		{
			return __touchCursorMap.get(sessionID);
		}
		return null;
	}
	
	public function addTouchObject(classID:Int, x:Float, y:Float, angle:Float):Void
	{
		//Profiler.log("add: "+touchObject);
		if (__touchObjectMap.get(classID) == null)
		{
			__touchObjectMap.set(classID, new TouchObject(classID, x, y, angle));
		}
	}
	public function updateTouchObject(classID:Int, x:Float, y:Float, angle:Float):Void
	{
		//Profiler.log("update: "+touchObject);
		if(__touchObjectMap.get(classID) != null)
		{
			__touchObjectMap.get(classID).update(x, y, angle);
		}
	}
	public function removeTouchObject(classID:Int):Void
	{
		//Profiler.log("remove: "+touchObject);
		if(__touchObjectMap.get(classID) != null)
		{
			__touchObjectMap.remove(classID);
		}
	}
	
	public function addTouchCursor(sessionID:Int, x:Float, y:Float):Void
	{
		//Profiler.log("add: "+touchCursor);
		if(__touchCursorMap.get(sessionID) != null) return;
		
		__touchCursorMap.set(sessionID, new TouchCursor(sessionID, x, y));
		
		var target:ITouchCursorHandler = TouchUtil.getDeepestTouchSpriteUnderPoint(new Point(x, y), __stage);
		
		if(target != null)
		{
			addTouchCursorToHolder(target, sessionID);
		}
	}
	public function updateTouchCursor(sessionID:Int, x:Float, y:Float):Void
	{
		//Profiler.log("update: "+touchCursor);
		if(__touchCursorMap.get(sessionID) != null)
		{
			__touchCursorMap.get(sessionID).update(x, y);
		}
	}
	public function removeTouchCursor(sessionID:Int):Void
	{
		//Profiler.log("remove: "+touchCursor);
		if(__touchCursorMap.get(sessionID) != null)
		{
			__touchCursorMap.remove(sessionID);
		}
	}
	private function touchesAliveHandler(aliveID:Array<Int>):Void
	{
		for(key in __touchCursorMap.keys())
		{
			if (aliveID.indexOf(key) < 0)
				removeTouchCursor(key);
		}
	}
	private function addTouchCursorToHolder(target:ITouchCursorHandler, sessionID:Int):Void
	{
		target.addTouchCursor(sessionID);
		
		if(target.bubbleEnabled == true)
		{
			var parentTouchSprite:ITouchCursorHandler = TouchUtil.getFirstEnabledParentTouchSprite(cast(target, DisplayObject));
			if(parentTouchSprite != null)
			{
				addTouchCursorToHolder(parentTouchSprite, sessionID);
			}
		}
	}
}