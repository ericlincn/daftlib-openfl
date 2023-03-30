package cn.daftlib.transitions;

import cn.daftlib.time.EnterFrame;
import cn.daftlib.utils.NumberUtil;
import cn.daftlib.utils.ReflectUtil;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author eric.lin
 */
private typedef EaseFunction = Dynamic;
 
@:final class Tween
{
	private var __target:Dynamic;
	private var __duration:Float;
	private var __vars:Dynamic;
	private var __ease:EaseFunction;
	private var __delay:Float;
	private var __reverse:Bool;

	private var __tweenInfoArr:Array<TweenInfo> = [];
	private var __startTime:Null<Float> = null;

	private var __onComplete:Dynamic;
	private var __onCompleteParams:Array<Dynamic>;
	private var __onUpdate:Dynamic;
	private var __onUpdateParams:Array<Dynamic>;

	public function new(target:Dynamic, duration:Float, vars:Dynamic, ease:EaseFunction, reverse:Bool = false)
	{
		__target = target;
		// Easing equations don't work when the duration is zero.
		__duration = duration == 0? 0.001:duration;
		__duration = NumberUtil.max(0.001, duration) * 1000;
		__vars = vars;
		__delay = vars.delay == null? 0:vars.delay;
		//__delay = ReflectUtil.getField(vars, "delay") == null? 0:ReflectUtil.getField(vars, "delay");
		__delay = NumberUtil.max(0, __delay) * 1000;
		__reverse = reverse;

		__onComplete = vars.onComplete == null? null:vars.onComplete;
		__onCompleteParams = vars.onCompleteParams == null? null:vars.onCompleteParams;

		__onUpdate = vars.onUpdate == null? null:vars.onUpdate;
		__onUpdateParams = vars.onUpdateParams == null? null:vars.onUpdateParams;

		if(ease == null)
			__ease = easeOut;
		else
			__ease = ease;

		initTweenInfo();
	}
	@:allow(cn.daftlib.transitions.TweenManager)
	private function start():Void
	{
		EnterFrame.addEventListener(render);
	}
	@:allow(cn.daftlib.transitions.TweenManager)
	private function destroy():Void
	{
		EnterFrame.removeEventListener(render);

		__target = null;
		__vars = null;
		__ease = null;
		__tweenInfoArr = null;

		__onComplete = null;
		__onCompleteParams = null;

		__onUpdate = null;
		__onUpdateParams = null;
	}

	private function initTweenInfo():Void
	{
		//for(var property:String in __vars)
		for(property in Reflect.fields(__vars))
		{
			//check property is invaild
			//if(__target.hasOwnProperty(property) == true)
			//#if flash
			//if (Reflect.hasField(__target, property) == true)
			//#end
			
			//trace(ReflectUtil.hasField (__target, property), __target.alpha, property);
			if(ReflectUtil.hasField (__target, property))
			{
				__tweenInfoArr.push(new TweenInfo(__target, property, ReflectUtil.getField(__target, property), ReflectUtil.getField(__vars, property) - ReflectUtil.getField(__target, property)));
			}
		}

		if(__reverse == true)
		{
			var i:Int = __tweenInfoArr.length;
			while((i--)>0)
			{
				var ti:TweenInfo = __tweenInfoArr[i];
				ti.start += ti.change;
				ti.change *= -1;

				//render at beginning, because __duration is always forced to be at least 0.001 since easing equations can't handle zero.
				ReflectUtil.setField(ti.target, ti.property, ti.start);
				//ti.target[ti.property] = ti.start;
			}
		}
	}
	private function render(e:Event):Void
	{
		//for destroy fix
		if(__tweenInfoArr == null)
			return;

		//time related
		if(__startTime == null)
			__startTime = Lib.getTimer() + __delay;
		var currentTime:Float = Lib.getTimer() - __startTime;

		//calculate factor
		var factor:Float = 1;
		if(currentTime < 0)
		{
			//for delay
			factor = 0;
		}
		else if(currentTime >= __duration)
		{
			//for complete
			currentTime = __duration;
		}
		else
		{
			//factor = this.__ease.apply(null, [currentTime, 0, 1, __duration]);
			factor = Reflect.callMethod(null, this.__ease, [currentTime, 0, 1, __duration]);
		}

		//Tween the property
		var i:Int = __tweenInfoArr.length;
		while((i--)>0)
		{
			var ti:TweenInfo = __tweenInfoArr[i];
			var targetValue:Float = ti.start + factor * ti.change;
			ReflectUtil.setField(ti.target, ti.property, targetValue);
			//ti.target. = targetValue;
			//if(ti.property=="alpha")
			//trace(ti.property, targetValue);
			//Reflect.setProperty(ti.target, ti.property, targetValue);
			//Reflect.setField(ti.target, ti.property, targetValue);
			//untyped ti.target[ti.property] = targetValue;
		}

		//on Update method
		if (__onUpdate != null)
			Reflect.callMethod(null, __onUpdate, __onUpdateParams);
			//__onUpdate.apply(null, __onUpdateParams);

		//on Complete
		if(currentTime == __duration)
		{
			if (__onComplete != null)
				Reflect.callMethod(null, __onComplete, __onCompleteParams);
				//__onComplete.apply(null, __onCompleteParams);

			TweenManager.removeTweenForTarget(__target);
		}
	}
	private static function easeOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		return 1 - (t = 1 - (t / d)) * t;
	}
}

private class TweenInfo
{
	public var target:Dynamic;
	public var property:String;
	public var start:Float;
	public var change:Float;

	public function new(t:Dynamic, p:String, s:Float, c:Float)
	{
		this.target = t;
		this.property = p;
		this.start = s;
		this.change = c;
	}
}