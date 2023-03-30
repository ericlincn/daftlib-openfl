package cn.daftlib.touch.clients;
import cn.daftlib.touch.interfaces.ITouchListener;
import openfl.display.Stage;
import openfl.events.MouseEvent;

/**
 * ...
 * @author eric.lin
 */
@:final class MouseClient
{
	private var __stage:Stage;
	private var __listerner:ITouchListener;
	
	public function new(listerner:ITouchListener, stage:Stage)
	{
		__listerner = listerner;
		__stage = stage;

		__stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
	}
	private function mouseDownHandler(e:MouseEvent):Void
	{
		__stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		__stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

		__listerner.addTouchCursor(0, e.stageX, e.stageY);
	}
	private function mouseMoveHandler(e:MouseEvent):Void
	{
		__listerner.updateTouchCursor(0, e.stageX, e.stageY);
	}
	private function mouseUpHandler(e:MouseEvent):Void
	{
		__stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		__stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

		__listerner.removeTouchCursor(0);
	}
}