package cn.daftlib.ui.components;

import cn.daftlib.display.DaftTextField;
import openfl.events.Event;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * ...
 * @author eric.lin
 */
//[Event(name = "resize", type = "flash.events.Event")]
 
class Lable extends DaftTextField
{
	public var font(null, set):String;
	public var size(null, set):Int;
	public var color(null, set):Int;
	
	private var __font:String = null;
	private var __size:Int = 20;
	private var __color:Int = 0x222222;

	private var __format:TextFormat;
	
	public function new() 
	{
		super();
		
		this.autoSize = TextFieldAutoSize.LEFT;

		__format = new TextFormat(__font, __size, __color);

		render();
	}
	#if !flash
	override function set_text(value:String):String
	{
		super.text = value;
		this.dispatchEvent(new Event(Event.RESIZE));
		return value;
	}
	#else
	@:setter(text) function set_text(value:String):Void
	{
		super.text = value;
		this.dispatchEvent(new Event(Event.RESIZE));
	}
	#end
	private function set_font(fontName:String):String
	{
		if(__font == fontName)
			return __font;
		
		__font = fontName;
		
		render();
		
		this.dispatchEvent(new Event(Event.RESIZE));
		
		return fontName;
	}
	private function set_size(value:Int):Int
	{
		if(__size == value)
			return __size;

		__size = value;

		render();
		
		this.dispatchEvent(new Event(Event.RESIZE));
		
		return value;
	}
	private function set_color(color:Int):Int
	{
		if(__color == color)
			return __color;

		__color = color;

		render();
		
		return color;
	}
	private function render():Void
	{
		__format.font = __font;
		__format.size = __size;
		__format.color = __color;

		this.defaultTextFormat = __format;
		this.setTextFormat(__format);
		var tmp:String = this.text;
		this.text = tmp;
	}
}