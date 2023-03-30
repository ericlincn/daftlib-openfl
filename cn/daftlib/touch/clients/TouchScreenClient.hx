package cn.daftlib.touch.clients;
import cn.daftlib.touch.interfaces.ITouchListener;
import openfl.display.Stage;
import openfl.events.TouchEvent;

/**
 * ...
 * @author eric.lin
 */
@:final class TouchScreenClient
{
	private var __stage:Stage;
	private var __listerner:ITouchListener;
	
	public function new(listerner:ITouchListener, stage:Stage)
	{
		__listerner = listerner;
		__stage = stage;

		__stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
		__stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
		__stage.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
	}
	private function touchBeginHandler(e:TouchEvent):Void
	{
		var id:Int = e.touchPointID;
		var x:Float = e.stageX;
		var y:Float = e.stageY;
		__listerner.addTouchCursor(id, x, y);
	}
	private function touchMoveHandler(e:TouchEvent):Void
	{
		var id:Int = e.touchPointID;
		var x:Float = e.stageX;
		var y:Float = e.stageY;
		__listerner.updateTouchCursor(id, x, y);
	}
	private function touchEndHandler(e:TouchEvent):Void
	{
		var id:Int = e.touchPointID;
		__listerner.removeTouchCursor(id);
	}
}