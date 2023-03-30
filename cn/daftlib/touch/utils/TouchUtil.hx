package cn.daftlib.touch.utils;
import cn.daftlib.touch.interfaces.ITouchCursorHandler;
import cn.daftlib.utils.GeomUtil;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.geom.Point;

/**
 * ...
 * @author eric.lin
 */
@:final class TouchUtil
{
	public static function getDeepestTouchSpriteUnderPoint(point:Point, stage:Stage):ITouchCursorHandler
	{
		var doTargets:Array<DisplayObject> = stage.getObjectsUnderPoint(point);
		var touchTargets:Array<ITouchCursorHandler> = [];

		var i:Int = 0;
		while(i < doTargets.length)
		{
			var parentTS:ITouchCursorHandler = getFirstEnabledParentTouchSprite(doTargets[i]);

			//if(doTargets[i] is ITouchCursorHandler)
			if(Std.is(doTargets[i], ITouchCursorHandler)==true)
			{
				var pushed:Bool = pushEnabledTarget(cast(doTargets[i], ITouchCursorHandler), touchTargets);

				if(pushed == false)
				{
					pushEnabledTarget(parentTS, touchTargets);
				}
			}
			else if(parentTS != null)
			{
				pushEnabledTarget(parentTS, touchTargets);
			}

			i++;
		}

		var item:ITouchCursorHandler = null;
		//trace("touchTargets", touchTargets)
		if(touchTargets.length > 0)
			item = touchTargets[touchTargets.length - 1];

		/*if(touchTargets.length > 0)
			item = touchTargets[0];*/

		return item;
	}
	private static function pushEnabledTarget(target:ITouchCursorHandler, arr:Array<ITouchCursorHandler>):Bool
	{
		if(target == null)
			return false;

		if(target.touchEnabled == true)
		{
			if(arr.indexOf(target) < 0)
			{
				arr.push(target);

				return true;
			}
		}

		return false;
	}
	public static function getFirstEnabledParentTouchSprite(displayObject:DisplayObject):ITouchCursorHandler
	{
		var ts:ITouchCursorHandler = null;

		if(displayObject.parent != null)
		{
			if(Std.is(displayObject.parent, ITouchCursorHandler) == true)
			{
				if(cast(displayObject.parent, ITouchCursorHandler).touchEnabled == true)
					ts = cast(displayObject.parent, ITouchCursorHandler);
			}

			if(ts == null)
			{
				ts = getFirstEnabledParentTouchSprite(displayObject.parent);
			}
		}

		return ts;
	}
	public static function getAngleTrig(vx:Float, vy:Float):Float
	{
		if(vx == 0)
		{
			if(vy < 0)
				return 270;
			else
				return 90;
		}
		else if(vy == 0)
		{
			if(vx < 0)
				return 180;
			else
				return 0;
		}

		if(vy > 0)
			if(vx > 0)
				return GeomUtil.radiansToDegrees(Math.atan(vy / vx));
			else
				return 180 - GeomUtil.radiansToDegrees(Math.atan(vy / -vx));
		else if(vx > 0)
			return 360 - GeomUtil.radiansToDegrees(Math.atan(-vy / vx));
		else
			return 180 + GeomUtil.radiansToDegrees(Math.atan(-vy / -vx));
	}
}