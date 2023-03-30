package cn.daftlib.observer;

/**
 * @author eric.lin
 */

interface INotification 
{
	var name(get, null):String;
	var body(get, null):Dynamic;
}