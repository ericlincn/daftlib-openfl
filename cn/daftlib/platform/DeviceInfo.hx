package cn.daftlib.platform;
import openfl.display.OpenGLView;

/**
 * ...
 * @author eric.lin
 */
@:final class DeviceInfo
{
	public static var hardwareRender(get, null):Bool;
	public static var platform(get, null):String;
	public static var operationSystem(get, null):String;
	public static var script(get, null):String;
	public static var isDebug(get, null):Bool;
	
	private static function get_hardwareRender():Bool
	{
		return OpenGLView.isSupported;
	}
	private static function get_platform():String
	{
		#if mobile
		return "mobile";
		#elseif desktop
		return "desktop";
		#elseif web
		return "web";
		#else
		return "unknown";
		#end
	}
	private static function get_operationSystem():String
	{
		#if ios
		return "ios";
		#elseif android
		return "android";
		#elseif blackberry
		return "blackberry";
		#elseif tizen
		return "tizen";
		#elseif windows
		return "windows";
		#elseif mac
		return "mac";
		#elseif linux 
		return "linux";
		#elseif html5 
		return "html5";
		#else
		return "unknown";
		#end
	}
	private static function get_script():String
	{
		#if cpp
		return "cpp";
		#elseif neko 
		return "neko";
		#elseif flash 
		return "flash";
		#elseif js 
		return "js";
		#else
		return "unknown";
		#end
	}
	private static function get_isDebug():Bool
	{
		#if debug
		return true;
		#else
		return false;
		#end
	}
}