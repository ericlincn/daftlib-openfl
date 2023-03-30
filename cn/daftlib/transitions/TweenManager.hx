package cn.daftlib.transitions;
import cn.daftlib.data.DynamicDictionary;
import openfl.display.DisplayObject;

/**
 * ...
 * @author eric.lin
 */
private typedef EaseFunction = Dynamic;

@:final class TweenManager
{
	private static var __tweenMap:DynamicDictionary<Tween> = new DynamicDictionary<Tween>();

	public static function to(target:Dynamic, duration:Float, vars:Dynamic, ease:EaseFunction = null):Void
	{
		//var oldTween:Tween = __tweenMap[target];
		var oldTween:Tween = __tweenMap.get(target);
		var newTween:Tween = new Tween(target, duration, vars, ease);

		if(oldTween != null)
		{
			oldTween.destroy();
			oldTween = null;
			//delete __tweenMap[target];
			__tweenMap.remove(target);
		}

		newTween.start();
		//__tweenMap[target] = newTween;
		__tweenMap.set(target, newTween);

		//return newTween;
	}
	public static function from(target:Dynamic, duration:Float, vars:Dynamic, ease:EaseFunction = null):Void
	{
		//var oldTween:Tween = __tweenMap[target];
		var oldTween:Tween = __tweenMap.get(target);
		var newTween:Tween = new Tween(target, duration, vars, ease, true);

		if(oldTween != null)
		{
			oldTween.destroy();
			oldTween = null;
			//delete __tweenMap[target];
			__tweenMap.remove(target);
		}

		newTween.start();
		//__tweenMap[target] = newTween;
		__tweenMap.set(target, newTween);

		//return newTween;
	}
	public static function delayCall(delay:Float, func:Dynamic, funcParams:Array<Dynamic> = null):Void
	{
		//var oldTween:Tween = __tweenMap[func];
		var oldTween:Tween = __tweenMap.get(func);
		var newTween:Tween = new Tween(func, 0, {delay:delay, onComplete:func, onCompleteParams:funcParams}, null);

		if(oldTween != null)
		{
			oldTween.destroy();
			oldTween = null;
			//delete __tweenMap[func];
			__tweenMap.remove(func);
		}

		newTween.start();
		//__tweenMap[func] = newTween;
		__tweenMap.set(func, newTween);

		//return newTween;
	}

	public static function removeTweenForTarget(target:Dynamic):Void
	{
		if (!target) return;
		//var oldTween:Tween = __tweenMap[target];
		var oldTween:Tween = __tweenMap.get(target);

		if(oldTween != null)
		{
			oldTween.destroy();
			oldTween = null;
			//delete __tweenMap[target];
			__tweenMap.remove(target);
		}
	}
	public static function removeDelayCallForMethod(func:Dynamic):Void
	{
		removeTweenForTarget(func);
	}
	public static function removeAllTween():Void
	{
		for(key in __tweenMap)
		{
			//if(key)
			removeTweenForTarget(key);
		}
		__tweenMap = new DynamicDictionary<Tween>();
	}
}