package cn.daftlib.core;

/**
 * @author eric.lin
 */

interface IRemovableEventDispatcher 
{
	function removeEventsForType(type:String):Void;
	function removeEventsForListener(listener:Dynamic -> Void):Void;
	function removeEventListeners():Void;
}