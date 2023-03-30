package cn.daftlib.utils;
import cn.daftlib.errors.UndefinedError;
import cn.daftlib.time.EnterFrame;
import openfl.display.DisplayObjectContainer;
import openfl.display.Stage;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
#if js
import cn.daftlib.platform.JavaScript;
#end

/**
 * ...
 * @author eric.lin
 */
@:final class StageReference
{
	public static var stage(get, null):Stage;
	public static var stageWidth(get, null):Int;
	public static var stageHeight(get, null):Int;
	public static var isCurrentlyPortrait(get, null):Bool;
	
	private static var __rootContainer:DisplayObjectContainer;
	private static var __callback:Void -> Void;
	private static var __stage:Stage;
	private static var __fitCanvas:Bool;
	
	public static function initialize(rootContainer:DisplayObjectContainer, callback:Void -> Void, rootMouseChildren:Bool = true, rootMouseEnabled:Bool = false, fitCanvas:Bool = false):Void
	{
		if(__rootContainer != null) return;
			//throw new DuplicateDefinedError(__rootContainer.toString());

		__rootContainer = rootContainer;
		__rootContainer.mouseChildren = rootMouseChildren;
		__rootContainer.mouseEnabled = rootMouseEnabled;
		__callback = callback;
		__fitCanvas = fitCanvas;

		EnterFrame.addEventListener(checkStageReference);
	}
	private static function get_stage():Stage
	{
		confirmStageReference();
		
		return __stage;
	}
	private static function get_stageWidth():Int
	{
		trace("[class StageReference]", 'Do not call get_stageWidth frequently.');
		
		confirmStageReference();
		
		return __stage.stageWidth;
	}
	private static function get_stageHeight():Int
	{
		trace("[class StageReference]", 'Do not call get_stageHeight frequently.');
		
		confirmStageReference();
		
		return __stage.stageHeight;
	}
	private static function get_isCurrentlyPortrait():Bool
	{
		confirmStageReference();
		
		return __stage.stageWidth < __stage.stageHeight;
	}
	private static function checkStageReference(e:Event):Void
	{
		if(__rootContainer.stage != null)
		{
			if(__rootContainer.stage.stageWidth > 0 && __rootContainer.stage.stageHeight > 0)
			{
				EnterFrame.removeEventListener(checkStageReference);

				__stage = __rootContainer.stage;
				__stage.align = StageAlign.TOP_LEFT;
				__stage.scaleMode = StageScaleMode.NO_SCALE;
				__stage.stageFocusRect = false;
				
				#if flash
				__stage.showDefaultContextMenu = false;
				#end
				
				#if js
				if (__fitCanvas == true)
				{
					JavaScript.fitCanvas();
					__stage.addEventListener(Event.RESIZE, function(e:Event):Void { JavaScript.fitCanvas(); } );
				}
				#end
				
				finishInit();
			}
		}
	}
	private static function finishInit():Void
	{
		if(__callback != null)
		{
			Reflect.callMethod(null, __callback, null);
			__callback = null;
		}
	}
	private static function confirmStageReference():Void
	{
		if(__stage == null)
			throw new UndefinedError("[class Stage]");
	}
}