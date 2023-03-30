package cn.daftlib.templates;

#if js
import cn.daftlib.platform.JavaScript;
#end

import lime.app.Application in LimeApplication;
import lime.app.Config in LimeConfig;
import lime.graphics.RenderContext;
import lime.ui.KeyCode;
import lime.ui.Mouse;
import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Point;
import openfl.ui.Keyboard;
import openfl.Lib;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Stage)


class Application extends openfl.display.Application
{	
	private var __scale:Float = 1;
	
	public function new()
	{
		super ();
	}
	
	
	#if !flash
	
	public override function create (config:LimeConfig):Void
	{
		super.create (config);
		
		#if js
		__scale = JavaScript.pixelDensity;
		#end
		
		stage.removeChild (Lib.current);
		stage.stage3Ds = null;
		stage = null;
		
		stage = new Stage (Std.int(window.width * __scale), Std.int(window.height * __scale), config.background);
		stage.addChild (Lib.current);
	}
	
	public override function onMouseDown (x:Float, y:Float, button:Int):Void
	{
		var type = switch (button) {
			
			case 1: MouseEvent.MIDDLE_MOUSE_DOWN;
			case 2: MouseEvent.RIGHT_MOUSE_DOWN;
			default: MouseEvent.MOUSE_DOWN;
			
		}
		
		onMouse (type, x * __scale, y * __scale, button);
		//Profiler.log(type, x * __scale, y * __scale, button);
	}
	
	public override function onMouseMove (x:Float, y:Float, button:Int):Void
	{
		onMouse (MouseEvent.MOUSE_MOVE, x * __scale, y * __scale, 0);	
		//Profiler.log(MouseEvent.MOUSE_MOVE, x * __scale, y * __scale, 0);
	}
	
	
	public override function onMouseUp (x:Float, y:Float, button:Int):Void
	{
		var type = switch (button)
		{
			case 1: MouseEvent.MIDDLE_MOUSE_UP;
			case 2: MouseEvent.RIGHT_MOUSE_UP;
			default: MouseEvent.MOUSE_UP;
		}
		
		onMouse (type, x * __scale, y * __scale, button);
		//Profiler.log(type, x * __scale, y * __scale, button);
	}
	
	
	public override function onTouchMove (x:Float, y:Float, id:Int):Void
	{
		onTouch (TouchEvent.TOUCH_MOVE, x * __scale, y * __scale, id);
		//Profiler.log(TouchEvent.TOUCH_MOVE, x * __scale, y * __scale, id);
	}
	
	
	public override function onTouchEnd (x:Float, y:Float, id:Int):Void
	{
		onTouch (TouchEvent.TOUCH_END, x * __scale, y * __scale, id);
		//Profiler.log(TouchEvent.TOUCH_END, x * __scale, y * __scale, id);
	}
	
	
	public override function onTouchStart (x:Float, y:Float, id:Int):Void
	{
		onTouch (TouchEvent.TOUCH_BEGIN, x * __scale, y * __scale, id);
		//Profiler.log(TouchEvent.TOUCH_BEGIN, x * __scale, y * __scale, id);
	}
	
	public override function onWindowResize (width:Int, height:Int):Void
	{
		stage.stageWidth = Std.int(width * __scale);
		stage.stageHeight = Std.int(height * __scale);
		
		var event = new openfl.events.Event (openfl.events.Event.RESIZE);
		stage.__broadcast (event, false);
	}
	
	#end
}