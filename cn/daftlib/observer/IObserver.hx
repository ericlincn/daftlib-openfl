package cn.daftlib.observer;

/**
 * @author eric.lin
 */

interface IObserver 
{
	function handlerNotification(notification:INotification):Void;
}