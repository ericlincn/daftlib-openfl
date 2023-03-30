package cn.daftlib.touch.interfaces;

/**
 * @author eric.lin
 */

interface ITouchListener 
{
	function addTouchObject(classID:Int, x:Float, y:Float, angle:Float):Void;
	function updateTouchObject(classID:Int, x:Float, y:Float, angle:Float):Void;
	function removeTouchObject(classID:Int):Void;
	function addTouchCursor(sessionID:Int, x:Float, y:Float):Void;
	function updateTouchCursor(sessionID:Int, x:Float, y:Float):Void;
	function removeTouchCursor(sessionID:Int):Void;
}