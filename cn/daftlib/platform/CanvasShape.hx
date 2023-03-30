package cn.daftlib.platform ;

import openfl.display.Graphics;
import openfl.display.Shape;
import openfl.display.Tilesheet;

/**
 * ...
 * @author eric.lin
 */
#if js
class CanvasShape extends Shape
{
	private var __viewportWidth:Float;
	private var __viewportHeight:Float;
	
	public function new(viewportWidth:Float, viewportHeight:Float) 
	{
		super();
		
		__viewportWidth = viewportWidth;
		__viewportHeight = viewportHeight;
	}
	override function get_graphics():Graphics 
	{
		if(__graphics == null)
		{
			var cg:CanvasGraphics = new CanvasGraphics();
			cg.viewportWidth = __viewportWidth;
			cg.viewportHeight = __viewportHeight;
			
			__graphics = cast(cg, Graphics);
		}
		return __graphics;
	}
}

private class CanvasGraphics extends Graphics
{
	public var viewportWidth:Float;
	public var viewportHeight:Float;
	
	public function new() 
	{
		super();
	}
	override public function drawTiles(sheet:Tilesheet, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0, count:Int = -1):Void 
	{
		__inflateBounds (0, 0);
		__inflateBounds (viewportWidth, viewportHeight);
		
		__commands.push (DrawTiles (sheet, tileData, smooth, flags, count));
		
		__dirty = true;
		__visible = true;
	}
}

#else
typedef CanvasShape = openfl._v2.display.Shape;
#end