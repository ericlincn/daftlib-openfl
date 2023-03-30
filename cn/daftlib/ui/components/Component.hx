package cn.daftlib.ui.components;

import cn.daftlib.display.DaftSprite;
import cn.daftlib.utils.BitmapDataUtil;
import cn.daftlib.utils.ColorUtil;
import openfl.display.BitmapData;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author eric.lin
 */
class Component extends DaftSprite
{
	private var __font:String = "Tahoma";
	private var __width:Int = 0;
	private var __height:Int = 0;
	
	public function new() 
	{
		super();
		
		this.mouseEnabled = true;
		
		addChildren();
		invalidate();
	}
	#if !flash
	override function set_width(value:Float):Float
	{
		value = Math.round(value);
		
		if(__width == value) return __width;
		
		__width = Std.int(value);
		
		invalidate();
		
		return value;
	}
	override function set_height(value:Float):Float
	{
		value = Math.round(value);
		
		if(__height == value) return __height;
		
		__height = Std.int(value);
		
		invalidate();
		
		return value;
	}
	override function get_width():Float
	{
		return __width;
	}
	override function get_height():Float
	{
		return __height;
	}
	#else
	@:setter(width) function set_width(value:Float):Void
	{
		value = Math.round(value);
		
		if(__width == value) return;
		
		__width = Std.int(value);
		
		invalidate();
	}
	@:setter(height) function set_height(value:Float):Void
	{
		value = Math.round(value);
		
		if(__height == value) return;
		
		__height = Std.int(value);
		
		invalidate();
	}
	@:getter(width) function get_width():Float
	{
		return __width;
	}
	@:getter(height) function get_height():Float
	{
		return __height;
	}
	#end
	
	/**
	 * Overriden in subclasses to create child display objects.
	 */	
	private function addChildren():Void
	{
		throw new Error('This function should be overrided by subclass.');
	}
	/**
	 * Do not call render() directly, call invalidate() instead
	 */		
	private function render():Void
	{
		throw new Error('This function should be overrided by subclass.');
	}
	/**
	 * Marks the component to be redrawn on the next frame.
	 */	
	private function invalidate():Void
	{
		this.addEventListener(Event.ENTER_FRAME, invalidateHandler);
	}
	/**
	 * Called one frame after invalidate is called.
	 */
	private function invalidateHandler(e:Event):Void
	{
		this.removeEventListener(Event.ENTER_FRAME, invalidateHandler);
		render();
	}

	private function getPlateTexture(width:Int, height:Int):BitmapData
	{
		var bmd:BitmapData = new BitmapData(width, height, false, 0xf3f3f3);
		
		bmd.fillRect(new Rectangle(0, 0, 3, height), 0xafafaf);
		bmd.fillRect(new Rectangle(0, 0, width, 3), 0xafafaf);
		
		return bmd;
	}
	private function getBackTexture(width:Int, height:Int):BitmapData
	{
		var bmd:BitmapData = new BitmapData(width, height, false, 0xcccccc);
		
		bmd.fillRect(new Rectangle(0, 0, 3, height), 0x909090);
		bmd.fillRect(new Rectangle(0, 0, width, 3), 0x909090);
		
		return bmd;
	}
	private function getShadowTexture(width:Int, height:Int):BitmapData
	{
		var bmd:BitmapData = new BitmapData(width, height, true, 0x0);
		
		bmd.fillRect(new Rectangle(0, 0, 3, height), 0x66000000);
		bmd.fillRect(new Rectangle(3, 0, width-3, 3), 0x66000000);
		
		return bmd;
	}
	private function getBlockTexture(width:Int, height:Int):BitmapData
	{
		var bmd:BitmapData = new BitmapData(width, height, true, 0x0);
		
		bmd.fillRect(new Rectangle(1, 1, width-2, height-2), 0xffffffff);
		bmd.fillRect(new Rectangle(2, height-1, width-2, 1), 0xff909090);
		bmd.fillRect(new Rectangle(width-1, 2, 1, height-2), 0xff909090);
		
		return bmd;
	}
	private function getPressBlockTexture(width:Int, height:Int):BitmapData
	{
		var bmd:BitmapData = new BitmapData(width, height, true, 0x0);
		
		bmd.fillRect(new Rectangle(2, 2, width-3, height-3), 0xffffffff);
		
		return bmd;
	}
}