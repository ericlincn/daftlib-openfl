package cn.daftlib.touch.display;
import cn.daftlib.touch.events.FingerGestureEvent;
import cn.daftlib.touch.utils.TouchUtil;
import cn.daftlib.touch.vo.TouchCursor;
import openfl.geom.Point;

/**
 * ...
 * @author eric.lin
 */
//[Event(name = "gestureRotateScale", type = "cn.daftlib.touch.events.FingerGestureEvent")]
 
class RotateScaleTouchSprite extends SlideTouchSprite
{
	private var ROTATE_SCALE:String = "rotateScale";

	private var __touchCursorCenter:TouchCursor;
	private var __localCenter:Point;
	
	public function new() 
	{
		super();
	}
	override public function destroy():Void
	{
		super.destroy();

		__touchCursorCenter = null;
		__localCenter = null;
	}
	override private function __updateState():Void
	{
		var prevState:String = __state;

		if(__touchCursorCloneArr.length == 1)
		{
			__state = SLIDE;
		}
		else if(__touchCursorCloneArr.length == 2)
		{
			__state = ROTATE_SCALE;

			__localCenter = getLocalCenter(__touchCursorCloneArr[0], __touchCursorCloneArr[1]);
			var globeCenter:Point = getGlobalCenter(__touchCursorCloneArr[0], __touchCursorCloneArr[1]);
			__touchCursorCenter = new TouchCursor(0, globeCenter.x, globeCenter.y);
		}
		else if(__touchCursorCloneArr.length >= 3)
		{
			__state = SLIDE;
		}
		else
		{
			__state = NONE;
		}

		//if(__state != prevState)
		{
			var i:Int = 0;
			while(i < __touchCursorCloneArr.length)
			{
				__touchCursorCloneArr[i] = getClone(__touchCursorCloneArr[i]);

				i++;
			}
		}
	}
	private function handleRotateScale(stageX:Float, stageY:Float, scale:Float, rotate:Float, registeX:Float, registeY:Float):Void
	{
		if(isListening(FingerGestureEvent.GESTURE_ROTATE_SCALE) == true)
		{
			var event:FingerGestureEvent = new FingerGestureEvent(FingerGestureEvent.GESTURE_ROTATE_SCALE);
			event.scaleRatio = scale;
			event.rotationDelta = rotate;
			event.registeX = registeX;
			event.registeY = registeY;
			event.stageX = stageX;
			event.stageY = stageY;
			this.dispatchEvent(event);

			if(__singleDirectionPan == false && __currentPanDirection == null)
			{
				__currentPanDirection = FREE;
			}
		}

		stopCountHoldTime(FingerGestureEvent.GESTURE_ROTATE_SCALE, true);
	}
	override private function __onRenderTick():Void
	{
		super.__onRenderTick();
		
		if(__state == ROTATE_SCALE)
		{
			var aPos:Point = new Point(__touchCursorCloneArr[0].x, __touchCursorCloneArr[0].y);
			var bPos:Point = new Point(__touchCursorCloneArr[1].x, __touchCursorCloneArr[1].y);

			var aStart:Point = new Point(__touchCursorCloneArr[0].startX, __touchCursorCloneArr[0].startY);
			var bStart:Point = new Point(__touchCursorCloneArr[1].startX, __touchCursorCloneArr[1].startY);

			var len1:Float = Point.distance(aStart, bStart);
			var len2:Float = Point.distance(aPos, bPos);
			var scaleRatio:Float = len2 / len1;

			var globeCenter:Point = getGlobalCenter(__touchCursorCloneArr[0], __touchCursorCloneArr[1]);
			__touchCursorCenter.update(globeCenter.x, globeCenter.y);

			var line:Point = aPos.subtract(bPos);
			var lineStart:Point = aStart.subtract(bStart);

			var ang1:Float = TouchUtil.getAngleTrig(lineStart.x, lineStart.y);
			var ang2:Float = TouchUtil.getAngleTrig(line.x, line.y);
			var rotationDelta:Float = ang2 - ang1;

			handleRotateScale(__touchCursorCenter.x, __touchCursorCenter.y, scaleRatio, rotationDelta, __localCenter.x, __localCenter.y);
			handlePan(__touchCursorCenter.x, __touchCursorCenter.y, __touchCursorCenter.offsetX, __touchCursorCenter.offsetY, __touchCursorCenter.speedX, __touchCursorCenter.speedY, __localCenter.x, __localCenter.y);
		}
	}
	private function getLocalCenter(touchCursorA:TouchCursor, touchCursorB:TouchCursor):Point
	{
		return Point.interpolate(this.globalToLocal(new Point(touchCursorA.x, touchCursorA.y)), this.globalToLocal(new Point(touchCursorB.x, touchCursorB.y)), 0.5);
	}
	private function getGlobalCenter(touchCursorA:TouchCursor, touchCursorB:TouchCursor):Point
	{
		return Point.interpolate(new Point(touchCursorA.x, touchCursorA.y), new Point(touchCursorB.x, touchCursorB.y), 0.5);
	}
}