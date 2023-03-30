package cn.daftlib.time;
import cn.daftlib.core.IDestroyable;
import openfl.errors.Error;
import openfl.events.Event;

/**
 * ...
 * @author eric.lin
 */
// Anonymous Structure: http://haxe.org/manual/types-structure-performance.html
private typedef FunctionInfo = {f:Void -> Void, i:Int};

@:final class IntervalFrame implements IDestroyable
{
	private var __functionArr:Array<FunctionInfo> = [];
	private var __frameCount:Int = 0;

	public function new()
	{
		__functionArr = [];
		__frameCount = 0;
	}
	public function destroy():Void
	{
		EnterFrame.removeEventListener(enterFrameHandler);
		
		__functionArr = null;
	}
	public function addEventListener(listener:Void -> Void, interval:Int = 1):Void
	{
		if(__functionArr == null) return;
		
		interval = Std.int(Math.max(1, interval));

		var i:Int = __functionArr.length;
		while((i--)>0)
		{
			var f:Void -> Void = __functionArr[i].f;
			if(f == listener)
			{
				throw new Error('The $listener has been registered.');
				return;
			}
		}

		__functionArr.push({f:listener, i:interval});

		if(__functionArr.length == 1)
			EnterFrame.addEventListener(enterFrameHandler);
	}
	public function removeEventListener(listener:Void -> Void):Void
	{
		if(__functionArr == null) return;
		
		if(__functionArr.length == 0)
			return;

		var i:Int = __functionArr.length;
		while((i--)>0)
		{
			var f:Void -> Void = __functionArr[i].f;
			if(f == listener)
				__functionArr.splice(i, 1);
		}

		if(__functionArr.length == 0)
		{
			EnterFrame.removeEventListener(enterFrameHandler);
			__frameCount = 0;
		}
	}
	private function enterFrameHandler(e:Event):Void
	{
		if(__functionArr == null) return;
		
		__frameCount++;

		var i:Int = __functionArr.length;
		while((i--)>0)
		{
			var f:Void -> Void = __functionArr[i].f;
			var interval:Int = __functionArr[i].i;
			if (__frameCount % interval == 0)
				Reflect.callMethod(null, f, null);
				//f.apply();
		}
	}
}