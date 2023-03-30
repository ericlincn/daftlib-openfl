package cn.daftlib.templates;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author eric.lin
 */
class Preloader extends NMEPreloader
{
	private var __barWidth:Float;
	private var __barHeight:Float;
	private var __bar:Sprite;
	
	public function new() 
	{
		super();
		
		onInit();
	}
	override public function onInit():Void
	{
		var margin = outline.x;
		var padding = progress.x - outline.x;
		
		__barWidth = outline.width + margin * 2;
		__barHeight = outline.height;
		__bar = new Sprite();
		__bar.addChild(outline);
		__bar.addChild(progress);
		this.addChild(__bar);
		
		outline.y = -outline.height * .5;
		progress.y = outline.y + padding;
		
		flash.Lib.current.stage.addEventListener(Event.RESIZE, resizeHandler);
		resizeHandler(null);
	}
	private function resizeHandler(e:Event):Void
	{
		var W:Float = flash.Lib.current.stage.stageWidth;
		var H:Float = flash.Lib.current.stage.stageHeight;
		
		if (W < __barWidth)
		{
			__bar.scaleX = W / __barWidth;
		}
		else
		{
			__bar.scaleX = 1;
		}
		__bar.x = W * .5 - __barWidth * __bar.scaleX * .5;
		__bar.y = H * .5 - outline.height * .5;
	}
}