package cn.daftlib.ui.components;
import openfl.display.Bitmap;

/**
 * ...
 * @author eric.lin
 */
class Panel extends Component
{
	private var __skin:Bitmap;
	
	public function new() 
	{
		super();
	}
	override private function addChildren():Void
	{
		__skin = new Bitmap();
		this.addChild(__skin);
	}
	override private function render():Void
	{
		__skin.bitmapData = getPlateTexture(__width, __height);
	}
}