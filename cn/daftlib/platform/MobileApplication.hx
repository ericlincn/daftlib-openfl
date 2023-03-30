package cn.daftlib.platform;

import openfl.display.Stage;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.system.Capabilities;

/**
 * ...
 * @author eric.lin
 */
@:final class MobileApplication
{
	public static var BACK:Int = 27;
	public static var MENU:Int = 16777234;
	public static var version(get, null):String;
	public static var pixelDensity(get, null):Float;
	public static var language(get, null):String;
	
	private static var __pixelDensity:Float = 0;
	private static var __backHandler:Void->Void = null;
	private static var __menuHandler:Void->Void = null;
	
	private static function get_version():String
	{
		return Lib.version;
	}
	private static function get_language():String
	{
		return Capabilities.language;
	}
	private static function get_pixelDensity():Float
	{
		if(__pixelDensity == 0)
		{
			var dpi:Float = Capabilities.screenDPI;
		
			if (dpi < 200)
				__pixelDensity = 1;
			else if (dpi < 300)
				__pixelDensity = 1.5;
			else
				__pixelDensity = 2;
		}
		
		return __pixelDensity;
	}
	public static function setAutoExit(stage:Stage, value:Bool):Void
	{
		if(value == true)
		{
			stage.addEventListener(Event.DEACTIVATE, deactiveHandler);
		}
		else
			stage.removeEventListener(Event.DEACTIVATE, deactiveHandler);
	}
	private static function deactiveHandler(e:Event):Void
	{
		exit();
	}
	public static function exit():Void
	{
		trace('[Class MobileApplication]', 'iOS didnt supports this method.');
		Lib.exit();
	}
	public static function overrideKeyBehavior(stage:Stage, keyCode:Int, callback:Void->Void):Void
	{
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		
		if(keyCode == BACK)
		{
			__backHandler = callback;
		}
		else if(keyCode == MENU)
		{
			__menuHandler = callback;
		}
		else
		{
			throw new Error('The keycode only support back and menu for now.');
		}
	}
	private static function keyUpHandler(e:KeyboardEvent):Void
	{
		if(e.keyCode == BACK && __backHandler != null)
		{
			e.stopImmediatePropagation ();
			Reflect.callMethod(null, __backHandler, null);
		}
		
		if(e.keyCode == MENU && __menuHandler != null)
		{
			e.stopImmediatePropagation ();
			Reflect.callMethod(null, __menuHandler, null);
		}
	}
}