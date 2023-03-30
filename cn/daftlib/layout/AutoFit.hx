package cn.daftlib.layout;
import cn.daftlib.errors.DuplicateDefinedError;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.geom.Point;

/**
 * ...
 * @author eric.lin
 */
// Anonymous Structure: http://haxe.org/manual/types-structure-performance.html
private typedef FitInfo = { xPercent:Float, yPercent:Float, 
							scaleXPercent:Float, scaleYPercent:Float, 
							offsetX:Float, offsetY:Float, width:Float, height:Float };

@:final class AutoFit
{
	private static var __stage:Stage;
	private static var __displayObjectMap:Map<DisplayObject, FitInfo> = new Map<DisplayObject, FitInfo>();

	public static var SCALE:Dynamic = {x:0, y:0, scaleX:1, scaleY:1};
	public static var SCALEX:Dynamic = {x:0, y:0, scaleX:1, scaleY:0};
	public static var SCALEY:Dynamic = {x:0, y:0, scaleX:0, scaleY:1};
	public static var CENTER_SCALEX:Dynamic = {x:.5, y:.5, scaleX:1, scaleY:0};
	public static var CENTER_SCALEY:Dynamic = {x:.5, y:.5, scaleX:0, scaleY:1};

	public static var TOP_LEFT:Dynamic = {x:0, y:0, scaleX:0, scaleY:0};
	public static var TOP_CENTER:Dynamic = {x:.5, y:0, scaleX:0, scaleY:0};
	public static var TOP_RIGHT:Dynamic = {x:1, y:0, scaleX:0, scaleY:0};
	public static var LEFT:Dynamic = {x:0, y:.5, scaleX:0, scaleY:0};
	public static var CENTER:Dynamic = {x:.5, y:.5, scaleX:0, scaleY:0};
	public static var RIGHT:Dynamic = {x:1, y:.5, scaleX:0, scaleY:0};
	public static var BOTTOM_LEFT:Dynamic = {x:0, y:1, scaleX:0, scaleY:0};
	public static var BOTTOM_CENTER:Dynamic = {x:.5, y:1, scaleX:0, scaleY:0};
	public static var BOTTOM_RIGHT:Dynamic = {x:1, y:1, scaleX:0, scaleY:0};

	public static function initialize(stage:Stage):Void
	{
		if(__stage == null)
		{
			__stage = stage;
			__stage.addEventListener(Event.RESIZE, onResize);
		}
		else
			throw new DuplicateDefinedError(__stage.toString());
	}

	public static function register(displayObject:DisplayObject, fitMode:Dynamic, offsetPoint:Point = null, width:Float = 0, height:Float = 0):Void
	{
		if(__stage == null)
			throw new Error('Please call "AutoFit.initialize" first.');

		if(offsetPoint == null)
			offsetPoint = new Point(0, 0);

		if(width == 0)
			width = displayObject.width;

		if(height == 0)
			height = displayObject.height;

		if(width == 0 || height == 0)
			width = height = 1;
		//throw new Error("Can't get the actual size of " + displayObject.toString() + ", please set a general value to $originalWidth & $originalHeight manually.");

		var info:FitInfo =
		{
			xPercent : fitMode.x,
			yPercent : fitMode.y,
			scaleXPercent : fitMode.scaleX,
			scaleYPercent : fitMode.scaleY,
			offsetX : offsetPoint.x,
			offsetY : offsetPoint.y,
			width : width,
			height : height
		}

		__displayObjectMap[displayObject] = info;

		fitOne(displayObject);
	}

	public static function unRegister(displayObject:DisplayObject):Void
	{
		if(__stage == null)
			throw new Error('Please call "AutoFit.initialize" first.');

		__displayObjectMap.remove(displayObject);
		//delete __displayObjectMap[displayObject];
	}

	private static function onResize(e:Event):Void
	{
		//for(var key:* in __displayObjectMap)
		for (key in __displayObjectMap.keys())
		{
			if(key != null)
				fitOne(key);
		}
	}
	private static function fitOne(displayObject:DisplayObject):Void
	{
		var stageWidth:Int = __stage.stageWidth;
		var stageHeight:Int = __stage.stageHeight;
		var info:FitInfo = __displayObjectMap[displayObject];
		var destX:Float = info.xPercent * stageWidth + info.offsetX;
		var destY:Float = info.yPercent * stageHeight + info.offsetY;

		displayObject.x = destX;
		displayObject.y = destY;

		var scaleX:Float = info.scaleXPercent * stageWidth / info.width;
		var scaleY:Float = info.scaleYPercent * stageHeight / info.height;

		// scaleX & scaleY, one of them is ZERO
		if((scaleX * scaleY == 0) && ((scaleX + scaleY) != 0))
			displayObject.scaleX = displayObject.scaleY = scaleX + scaleY;
		else
		{
			if(scaleX != 0)
				displayObject.scaleX = scaleX;
			if(scaleY != 0)
				displayObject.scaleY = scaleY;
		}
	}
}