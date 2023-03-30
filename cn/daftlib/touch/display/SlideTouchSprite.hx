package cn.daftlib.touch.display;
import cn.daftlib.touch.events.FingerGestureEvent;
import cn.daftlib.utils.NumberUtil;

/**
 * ...
 * @author eric.lin
 */
//[Event(name = "gesturePan", type = "cn.daftlib.touch.events.FingerGestureEvent")]
 
class SlideTouchSprite extends TouchSprite
{
	private var MIN_OFFSET:Int = 15;

	//protected
	private var SLIDE:String = "slide";

	// related to oneDirectionPan
	private var HORIZONTAL:String = "horizontal";
	private var VERTICAL:String = "vertical";
	//protected
	private var FREE:String = "free";

	//protected
	private var __singleDirectionPan:Bool = true;
	private var __currentPanDirection:String = null;

	//private var __panFix:Point=null;

	public function new()
	{
		super();
	}
	override private function __updateState():Void
	{
		var prevState:String = __state;

		if(__touchCursorCloneArr.length >= 1)
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
	override private function __onTouchEnd():Void
	{
		// reset currentPanDirection
		__currentPanDirection = null;
	}
	private function handlePan(stageX:Float, stageY:Float, offsetX:Float, offsetY:Float, speedX:Float, speedY:Float, registeX:Float = 0, registeY:Float = 0):Void
	{
		if(NumberUtil.abs(offsetX) > MIN_OFFSET || NumberUtil.abs(offsetY) > MIN_OFFSET || __currentPanDirection != null)
		{
			if(isListening(FingerGestureEvent.GESTURE_PAN) == true)
			{
				var event:FingerGestureEvent = new FingerGestureEvent(FingerGestureEvent.GESTURE_PAN);
				event.offsetX = offsetX;
				event.offsetY = offsetY;
				event.speedX = speedX;
				event.speedY = speedY;
				event.registeX = registeX;
				event.registeY = registeY;
				event.stageX = stageX;
				event.stageY = stageY;

				// lock currentPanDirection
				if(__singleDirectionPan == true && __currentPanDirection == null)
				{
					if(NumberUtil.abs(offsetX) > NumberUtil.abs(offsetY))
						__currentPanDirection = HORIZONTAL;
					else if(NumberUtil.abs(offsetX) < NumberUtil.abs(offsetY))
						__currentPanDirection = VERTICAL;
				}
				else if(__singleDirectionPan == false && __currentPanDirection == null)
				{
					__currentPanDirection = FREE;
				}

				// filter the x/y offset based on the currentPanDirection 
				if(__currentPanDirection == HORIZONTAL)
					event.offsetY = event.speedY = 0;
				else if(__currentPanDirection == VERTICAL)
					event.offsetX = event.speedX = 0;

				this.dispatchEvent(event);
			}

			stopCountHoldTime(FingerGestureEvent.GESTURE_PAN, true);
		}
	}
	override private function __onRenderTick():Void
	{
		if(__state == SLIDE)
		{
			handlePan(__touchCursorCloneArr[0].x, __touchCursorCloneArr[0].y, __touchCursorCloneArr[0].offsetX, __touchCursorCloneArr[0].offsetY, __touchCursorCloneArr[0].speedX, __touchCursorCloneArr[0].speedY);
		}
	}
}