package cn.daftlib.ui.components;
import cn.daftlib.utils.BitmapDataUtil;
import cn.daftlib.utils.DisplayObjectUtil;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.events.MouseEvent;

/**
 * ...
 * @author eric.lin
 */
class PushButton extends Component
{
	private static var DOWN:Int = 1;
	private static var UP:Int = 0;
	
	public var lable(get, null):Lable;
	
	private var __label:Lable;
	private var __bg:Bitmap;
	private var __btn:Bitmap;
	private var __state:Int = UP;
	
	public function new() 
	{
		super();
	}
	private function get_lable():Lable
	{
		return __label;
	}
	override private function addChildren():Void
	{
		__bg=new Bitmap();
		this.addChild(__bg);
		
		__btn = new Bitmap();
		__btn.x = __btn.y = 1;
		this.addChild(__btn);
		
		__label=new Lable();
		__label.addEventListener(Event.RESIZE, childResizeHandler);
		__label.color = 0x0;
		__label.font = __font;
		this.addChild(__label);
		
		__width=200;
		__height=40;
		
		this.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
	}
	private function downHandler(e:MouseEvent):Void
	{
		__state=DOWN;
		updateTexture();
		stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
	}
	private function upHandler(e:MouseEvent):Void
	{
		__state=UP;
		updateTexture();
		stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler); 
	}
	private function childResizeHandler(e:Event):Void
	{
		__label.x=this.width*.5-__label.width*.5;
		__label.y=this.height*.5-__label.height*.5-1;
		invalidate();
	}
	override private function render():Void
	{
		updateTexture();
		
		__label.x=this.width*.5-__label.width*.5;
		__label.y=this.height*.5-__label.height*.5-1;
	}
	private function updateTexture():Void
	{
		if(__state == DOWN)
			__btn.bitmapData = getPressBlockTexture(__width-2, __height-2);
		else if(__state == UP)
			__btn.bitmapData = getBlockTexture(__width-2, __height-2);
			
		__bg.bitmapData = getBackTexture(__width, __height);
	}
}