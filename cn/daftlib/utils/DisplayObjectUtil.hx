package cn.daftlib.utils;
import cn.daftlib.core.IDestroyable;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.InteractiveObject;
import openfl.display.Loader;
import openfl.display.Sprite;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.media.SoundTransform;

/**
 * ...
 * @author eric.lin
 */
@:final class DisplayObjectUtil
{
	#if flash
	public static function setVolume(target:Sprite, volume:Float):Void
	{
		var transform:SoundTransform = target.soundTransform;
		transform.volume = volume;
		target.soundTransform = transform;
	}
	#end
	public static function setTint(target:DisplayObject, color:Int):Void
	{
		var ct:ColorTransform = target.transform.colorTransform;
		ct.color = color;
		target.transform.colorTransform = ct;
	}
	public static function destroyAllChildrenIn(container:DisplayObjectContainer):Void
	{
		while(container.numChildren > 0)
		{
			if(Std.is(container.getChildAt(0), IDestroyable) == true)
				cast(container.getChildAt(0), IDestroyable).destroy();
			else
			{
				if(Std.is(container.getChildAt(0), Loader) == true)
				#if flash
				cast(container.getChildAt(0), Loader).unloadAndStop();
				#else
				cast(container.getChildAt(0), Loader).unload();
				#end

				container.removeChildAt(0);
			}
		}
	}
	public static function smoothAllChildrenIn(container:DisplayObjectContainer, recursive:Bool = false):Void
	{
		var i:Int = container.numChildren;
		while((i--)>0)
		{
			var d:DisplayObject = container.getChildAt(i);
			if(Std.is(d, Bitmap) == true)
				cast(d, Bitmap).smoothing = true;

			if(recursive == true && Std.is(d, DisplayObjectContainer))
			{
				smoothAllChildrenIn(cast(d, DisplayObjectContainer), true);
			}
		}
	}
	public static function setPropertyByRegistration(target:DisplayObject, regPoint:Point, prop:String, value:Float):Void
	{
		var A:Point = target.parent.globalToLocal(target.localToGlobal(regPoint));

		if(prop == "x" || prop == "y")
		{
			//target[prop] += value - A[prop];
			ReflectUtil.setField(target, prop, ReflectUtil.getField(target, prop) + value - ReflectUtil.getField(A, prop));
		}
		else if(prop == "scaleX" || prop == "scaleY" || prop == "rotation")
		{
			//target[prop] = value;
			ReflectUtil.setField(target, prop, value);
			
			//执行旋转等属性后，再重新计算全局坐标
			var B:Point = target.parent.globalToLocal(target.localToGlobal(regPoint));
			//把注册点从B点移到A点
			target.x += A.x - B.x;
			target.y += A.y - B.y;
		}
	}
	public static function getTopDisplayObjectUnderPoint(point:Point, stage:DisplayObjectContainer):DisplayObject
	{
		var targets:Array<DisplayObject> = stage.getObjectsUnderPoint(point);
		var item:DisplayObject = (targets.length > 0) ? targets[targets.length - 1] : stage;

		return item;
	}
	public static function flipHorizontal(target:DisplayObject):Void
	{
		var matrix:Matrix = target.transform.matrix;
		matrix.a = -1;
		matrix.tx = target.width + target.x;
		target.transform.matrix = matrix;
	}
	public static function flipVertical(target:DisplayObject):Void
	{
		var matrix:Matrix = target.transform.matrix;
		matrix.d = -1;
		matrix.ty = target.height + target.y;
		target.transform.matrix = matrix;
	}
	public static function fadein(target:DisplayObject, step:Float = .1, destAlpha:Float = 1):Void
	{
		if(target.alpha < destAlpha)
			target.alpha = Math.min(destAlpha, target.alpha + step);
	}
	public static function fadeout(target:DisplayObject, step:Float = .1, destAlpha:Float = 0):Void
	{
		if(target.alpha > destAlpha)
			target.alpha = Math.max(destAlpha, target.alpha - step);
	}
	public static function sortAllChildrenByZ(container:DisplayObjectContainer):Void
	{
		if(container.numChildren <= 0)
			return;

		var arr:Array<DisplayObject> = [];
		var i:Int = container.numChildren;
		while((i--)>0)
		{
			arr.push(container.getChildAt(i));
		}

		//arr.sortOn("z", Array.NUMERIC | Array.DESCENDING);
		arr.sort(sortByZ);

		i = container.numChildren;
		while((i--)>0)
		{
			container.setChildIndex(arr[i], i);
		}
	}
	private static function sortByZ(a:DisplayObject, b:DisplayObject):Int
	{
		if (ReflectUtil.getField(a, "z") > ReflectUtil.getField(b, "z"))
			return 1;
		else if (ReflectUtil.getField(a, "z") < ReflectUtil.getField(b, "z"))
			return -1;
		
		return 0;
	}
	public static function printAllChildrenIn(container:DisplayObjectContainer, recursive:Bool = false):String
	{
		var outStr:String = "";
		var i:Int = container.numChildren;
		while((i--)>0)
		{
			var d:DisplayObject = container.getChildAt(i);
			outStr += "DisplayObject: " + d + "	Depth: " + i + "	Name: " + d.name;
			outStr += "	Width: " + d.width + "	Height: " + d.height + "	Parent: " + d.parent;
			if(Std.is(d, InteractiveObject) == true)
				outStr += "	MouseEnabled: " + cast(d, InteractiveObject).mouseEnabled;
			if(Std.is(d, DisplayObjectContainer) == true)
				outStr += "	MouseChildren: " + cast(d, DisplayObjectContainer).mouseChildren;
			if(i > 0)
				outStr += "\n";

			if(recursive == true && Std.is(d, DisplayObjectContainer))
			{
				outStr += printAllChildrenIn(cast(d, DisplayObjectContainer), true);
			}
		}
		return outStr == "" ? null : outStr;
	}
}