package cn.daftlib.media;

/**
 * @author eric.lin
 */

interface IMedia 
{
	var source(null, set):String;
	var loop(null, set):Bool;
	var volume(null, set):Float;
	var pan(null, set):Float;
	//var playingTime(null, set):Int;

	var totalTime(get, null):Int;
	//var playingTime(get, null):Int;
	var playingPercent(get, null):Float;
	var loadingPercent(get, null):Float;
	
	var playingTime(get, set):Float;

	function pause():Void;
	function resume():Void;
}