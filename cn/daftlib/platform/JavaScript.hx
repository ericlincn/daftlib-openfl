package cn.daftlib.platform;

//import cn.daftlib.utils.StageReference;
//import cn.daftlib.touch.TouchListener;
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.TouchEvent;
import openfl.external.ExternalInterface;

/**
 * ...
 * @author eric.lin
 */
@:final class JavaScript
{
	public static var title(get, null):String;
	public static var url(get, null):String;
	public static var cookieEnabled(get, null):Bool;
	public static var language(get, null):String;
	public static var userAgent(get, null):String;
	public static var hostname(get, null):String;
	public static var href(get, null):String;
	public static var pathname(get, null):String;
	public static var port(get, null):String;
	public static var protocol(get, null):String;
	public static var search(get, null):String;
	public static var pixelDensity(get, null):Float;
	
	private static var __callback:Array<Int> -> Void;
	
	public static function closeWindow():Void
	{
		ExternalInterface.call('window.close');
	}
	public static function alert(message:String):Void
	{
		ExternalInterface.call('window.alert', message);
	}
	private static function get_title():String
	{
		return Browser.document.title;
	}
	private static function get_url():String
	{
		return Browser.document.URL;
	}
	private static function get_cookieEnabled():Bool
	{
		return Browser.navigator.cookieEnabled;
	}
	// zh-cn简体中文
	private static function get_language():String
	{
		return Browser.navigator.language;
	}
	// Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) 
	// Chrome/43.0.2357.124 Safari/537.36
	private static function get_userAgent():String
	{
		return Browser.navigator.userAgent;
	}
	// 域名
	private static function get_hostname():String
	{
		return Browser.location.hostname;
	}
	// Full url, same as getPageURL()
	private static function get_href():String
	{
		return Browser.location.href;
	}
	// Folder part of url
	private static function get_pathname():String
	{
		return Browser.location.pathname;
	}
	private static function get_port():String
	{
		return Browser.location.port;
	}
	// http:, file:
	private static function get_protocol():String
	{
		return Browser.location.protocol;
	}
	// behind "?"
	private static function get_search():String
	{
		return Browser.location.search;
	}
	private static function get_pixelDensity():Float
	{
		var canvas:CanvasElement = cast Browser.document.getElementById("openfl-content").children.item(0);
		
		var context:CanvasRenderingContext2D = canvas.getContext('2d');
		
		var devicePixelRatio:Null<Float> = Browser.window.devicePixelRatio;
		devicePixelRatio = devicePixelRatio == null? 1:devicePixelRatio;
		
		var backingStoreRatio:Null<Float> = untyped(context).webkitBackingStorePixelRatio;
		backingStoreRatio = backingStoreRatio == null? untyped(context).mozBackingStorePixelRatio:backingStoreRatio;
		backingStoreRatio = backingStoreRatio == null? untyped(context).msBackingStorePixelRatio:backingStoreRatio;
		backingStoreRatio = backingStoreRatio == null? untyped(context).oBackingStorePixelRatio:backingStoreRatio;
		backingStoreRatio = backingStoreRatio == null? untyped(context).backingStorePixelRatio:backingStoreRatio;
		backingStoreRatio = backingStoreRatio == null? 1:backingStoreRatio;
		
		var ratio:Float = devicePixelRatio / backingStoreRatio;
		ratio = ratio == 3? 2:ratio;
		
		return ratio;
		
		/* From flambe
		// Calculate the scale, but bail early if this would cause the canvas to be larger than some
        // magic threshold. This was added to disable the retina display on the iPad 3, as
        // performance plummets there when scaling such a huge canvas
        var scale = devicePixelRatio / backingStorePixelRatio;
        var screenWidth = Browser.window.screen.width;
        var screenHeight = Browser.window.screen.height;
        if (scale*screenWidth > 1136 || scale*screenHeight > 1136) {
            return 1;
        }
		*/
	}
	public static function isAndroid():Bool
	{
		return ~/Android/i.match(Browser.navigator.userAgent);
	}
	public static function isAndroidPhone():Bool
	{
		return ~/Android/i.match(Browser.navigator.userAgent) && ~/Mobile/i.match(Browser.navigator.userAgent);
	}
	public static function isiOS():Bool
	{
		return ~/(iPad|iPhone|iPod)/i.match(Browser.navigator.userAgent);
	}
	public static function isiOSPhone():Bool
	{
		return ~/(iPhone|iPod)/i.match(Browser.navigator.userAgent);
	}
	public static function isWindows():Bool
	{
		return ~/(Windows|iemobile)/i.match(Browser.navigator.userAgent);
	}
	public static function isWindowsPhone():Bool
	{
		return ~/Windows Phone/i.match(Browser.navigator.userAgent) || ~/iemobile/i.match(Browser.navigator.userAgent);
	}
	public static function getiOSVersion():Array<Int>
	{
		var v:EReg = ~/[0-9_]+?[0-9_]+?[0-9_]+/i;
		var matched:Array<Int> = [];
		if (v.match(Browser.navigator.userAgent))
		{
			var match:Array<String> = v.matched(0).split("_");
			matched = [for (i in match) Std.parseInt(i)];
		}
		return matched;
	}
	
	@:allow(cn.daftlib.utils.StageReference)
	private static function fitCanvas():Void
	{
		var canvas:CanvasElement = cast Browser.document.getElementById("openfl-content").children.item(0);
		canvas.width = Browser.window.innerWidth;
		canvas.height = Browser.window.innerHeight;
		
		var context:CanvasRenderingContext2D = canvas.getContext('2d');
		context.imageSmoothingEnabled = false;
		var ratio:Float = get_pixelDensity();

		if(ratio != 1)
		{

			var oldWidth:Int = canvas.width;
			var oldHeight:Int = canvas.height;

			canvas.width = Std.int(oldWidth * ratio);
			canvas.height = Std.int(oldHeight * ratio);

			canvas.style.width = oldWidth + 'px';
			canvas.style.height = oldHeight + 'px';

			// now scale the context to counter
			// the fact that we've manually scaled
			// our canvas element
			context.scale(ratio, ratio);
		}
	}
	
	@:allow(cn.daftlib.touch.TouchListener)
	private static function fixCanvasTouchEnd(callback:Array<Int> -> Void):Void
	{
		__callback = callback;
		
		var canvas:CanvasElement = cast Browser.document.getElementById("openfl-content").children.item(0);
		
		canvas.addEventListener ("touchstart", handleTouchEvent, true);
		canvas.addEventListener ("touchmove", handleTouchEvent, true);
		canvas.addEventListener ("touchend", handleTouchEvent, true);
		canvas.addEventListener ("touchcancel", handleTouchEvent, true);
	}
	private static function handleTouchEvent(event:TouchEvent):Void
	{
		var result:Array<Int> = [];
		var alive = event.touches;
		var i:Int = 0;
		while (i < alive.length)
		{
			var touch = event.touches[i];
			result.push(touch.identifier);
			i++;
		}
		
		Reflect.callMethod(null, __callback, [result]);
	}
	
	/*From BitmapData
	private function __createCanvas (width:Int, height:Int):Void
	{
		if (__sourceCanvas == null)
		{
			__sourceCanvas = cast Browser.document.createElement ("canvas");		
			__sourceCanvas.width = width;
			__sourceCanvas.height = height;
			
			if (!transparent)
			{
				if (!transparent) __sourceCanvas.setAttribute ("moz-opaque", "true");
				__sourceContext = untyped __js__ ('this.__sourceCanvas.getContext ("2d", { alpha: false })');
				
			}
			else
			{
				__sourceContext = __sourceCanvas.getContext ("2d");
			}
			
			untyped (__sourceContext).mozImageSmoothingEnabled = false;
			untyped (__sourceContext).webkitImageSmoothingEnabled = false;
			__sourceContext.imageSmoothingEnabled = false;
			__valid = true;
		}
	}*/
}