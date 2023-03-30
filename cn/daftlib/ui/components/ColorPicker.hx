package cn.daftlib.ui.components;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

/**
 * ...
 * @author eric.lin
 */
class ColorPicker extends Component
{
	private var __bg:Bitmap;
	private var __shadow:Bitmap;
	private var __color:Int;
	
	public function new() 
	{
		super();
	}
	override private function addChildren():Void
	{
		__bg = new Bitmap();
		this.addChild(__bg);
		
		__shadow = new Bitmap();
		this.addChild(__shadow);
		
		__width=32;
		__height = 32;
		__color = 0x01cc99;
	}
	override private function render():Void
	{
		__bg.bitmapData = new BitmapData(__width, __height, false, __color);
		__shadow.bitmapData = getShadowTexture(__width, __height);
	}
}