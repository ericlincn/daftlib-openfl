package cn.daftlib.touch.interfaces;

/**
 * @author eric.lin
 */

interface ITouchCursorHandler 
{
	var touchEnabled(get, set):Bool;
	var bubbleEnabled(get, null):Bool;
	function addTouchCursor(sessionID:Int):Void;
}