package cn.daftlib.touch.components;

/**
 * @author eric.lin
 */

interface IItemRenderer 
{
	var itemWidth(get, null):Float;
	var itemHeight(get, null):Float;
	#if !flash
	@:isVar var visible(get, set):Bool;
	#end
}