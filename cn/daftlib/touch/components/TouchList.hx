package cn.daftlib.touch.components;

import cn.daftlib.touch.display.SlideTouchSprite;
import cn.daftlib.touch.events.FingerEvent;
import cn.daftlib.touch.events.FingerGestureEvent;
import cn.daftlib.touch.interfaces.ITouchCursorHandler;
import cn.daftlib.utils.DisplayObjectUtil;
import cn.daftlib.utils.NumberUtil;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;

/**
 * ...
 * @author eric.lin
 */
class TouchList extends SlideTouchSprite
{
	private var __list:Sprite;
	private var __listSize:Float = 0;
	private var __listStartPosition:Float = 0; // initial list position on touch 
	private var __listDownPosition:Float = 0;
	private var __viewportWidth:Int = 0;
	private var __scrollSpeed:Float = 0;
	private var __targetY:Float = 0;

	private var __isTouching:Bool = false;
	private var __viewportHeight:Int = 0;
	private var __inertia:Float = 0; // fraction or slide speed, take in charge when mouseUp
	//private var __offsetRevise:Number = 0;
	
	private var __touchEnabledMap:Map<ITouchCursorHandler, Bool>;

	public function new(viewportWidth:Int, viewportHeight:Int)
	{
		super();

		__viewportWidth = viewportWidth;
		__viewportHeight = viewportHeight;

		this.addEventListener(FingerEvent.FINGER_BEGIN, onBegin);
		this.addEventListener(FingerEvent.FINGER_END, onEnd);
		this.addEventListener(FingerEvent.FINGER_DOWN, onMouseDown);
		this.addEventListener(FingerEvent.FINGER_UP, onMouseUp);
		this.addEventListener(FingerGestureEvent.GESTURE_PAN, onMouseMove);
		this.addEventListener(Event.ENTER_FRAME, onRender);

		creatList();
	}
	override public function destroy():Void
	{
		DisplayObjectUtil.destroyAllChildrenIn(__list);

		super.destroy();

		__list = null;
	}
	public function addItem(item:IItemRenderer):Void
	{
		cast(item, DisplayObject).y = __listSize;
		__listSize += item.itemHeight;
		__list.addChild(cast(item, DisplayObject));
	}
	private function creatList():Void
	{
		var transparentBMD:BitmapData = new BitmapData(__viewportWidth, __viewportHeight, true, 0x0);

		var listHitArea:Bitmap = new Bitmap(transparentBMD);
		this.addChild(listHitArea);

		//var maskArea:Bitmap = new Bitmap(transparentBMD);
		//this.addChild(maskArea);

		__list = new Sprite();
		// Android performance killer !? FPS will drop down to single digit !!!
		// Mask will trigger the software rendering, NEVER using mask !!!
		//__list.mask = maskArea;
		// Using scrollRect instead
		this.scrollRect = new Rectangle(0, 0, __viewportWidth, __viewportHeight);
		this.addChild(__list);
	}
	private function onBegin(e:FingerEvent):Void
	{
		__listStartPosition = __list.y;
		__scrollSpeed = 0;

		//reset inertia
		__inertia = 0;
		//__offsetRevise=0;

		__targetY = __list.y;
	}
	private function onEnd(e:FingerEvent):Void
	{
		__isTouching = false;
	}
	private function onMouseDown(e:FingerEvent):Void
	{
		__listDownPosition = __targetY;
	}
	private function onMouseUp(e:FingerEvent):Void
	{
		__listDownPosition = __targetY;
	}
	private function onMouseMove(e:FingerGestureEvent):Void
	{
		__isTouching = true;

		__scrollSpeed = e.speedY;
		__inertia = NumberUtil.abs(e.speedY);
		__inertia = NumberUtil.min(__inertia, 150);
		__targetY = __listDownPosition + e.offsetY;

		var offset:Float = __targetY - __listStartPosition;

		var cannotScrollDown:Bool = __targetY > 0;
		var cannotScrollUp:Bool = (__listSize >= __viewportHeight && __targetY < __viewportHeight - __listSize) || (__listSize < __viewportHeight && __targetY < 0);
		var isShortList:Bool = __listSize < __viewportHeight;

		if(cannotScrollDown == true && offset >= 0)
		{
			__inertia = Math.sqrt(__targetY - 0) * 3;
			__list.y = __inertia;
		}
		else if(cannotScrollUp == true && offset <= 0)
		{
			if(isShortList == true)
			{
				__inertia = Math.sqrt(0 - __targetY) * 3;
				__list.y = -__inertia;
			}
			else
			{
				__inertia = Math.sqrt(__viewportHeight - __listSize - __targetY) * 3;
				__list.y = __viewportHeight - __listSize - __inertia;
			}
		}
		else
		{
			__list.y = __targetY;
		}

		//trace(e.offsetY, __offsetRevise, offset, __list.y);

		tryToDisableTouch();
	}
	private function onRender(e:Event):Void
	{
		// scroll the list on mouse up
		if(!__isTouching)
		{
			var cannotScrollDown:Bool = __targetY > 0;
			var cannotScrollUp:Bool = (__listSize >= __viewportHeight && __targetY < __viewportHeight - __listSize) || (__listSize < __viewportHeight && __targetY < 0);
			var isShortList:Bool = __listSize < __viewportHeight;

			if(cannotScrollDown == true)
			{
				__inertia *= .8;

				__targetY = __inertia;

				__scrollSpeed = 0;
			}
			else if(cannotScrollUp == true)
			{
				if(isShortList == true)
				{
					__inertia *= .8;

					__targetY = -__inertia;
				}
				else
				{
					__inertia *= .8;

					__targetY = __viewportHeight - __listSize - __inertia;
				}

				__scrollSpeed = 0;
			}
			else
			{
				__inertia *= .95;

				__targetY += __scrollSpeed;

				__scrollSpeed *= .95;
			}
			__list.y = __targetY;

			if(__scrollSpeed < 10 && __inertia < 1)
				tryToEnableTouch();
		}
	}
	private function tryToDisableTouch():Void
	{
		if(__touchEnabledMap == null)
		{
			__touchEnabledMap = new Map<ITouchCursorHandler, Bool>();
			var i:Int = __list.numChildren;
			while((i--)>0)
			{
				if(Std.is(__list.getChildAt(i), ITouchCursorHandler))
				{
					var tc:ITouchCursorHandler = cast(__list.getChildAt(i), ITouchCursorHandler);
					__touchEnabledMap[tc] = tc.touchEnabled;
					tc.touchEnabled = false;
				}
			}
		}
	}
	private function tryToEnableTouch():Void
	{
		if(__touchEnabledMap != null)
		{
			for(key in __touchEnabledMap.keys())
			{
				key.touchEnabled = __touchEnabledMap[key];
			}
			__touchEnabledMap = null;
		}
	}
}