package cn.daftlib.utils;

/**
 * ...
 * @author eric.lin
 */
@:final class DictionaryUtil
{
	public static function getDictionaryLength<T, Y>(map:Map<T, Y>):Int
	{
		var i:Int = 0;
		for(key in map.keys())
		{
			i++;
		}
		return i;
	}
	public static function printDictionary<T, Y>(map:Map<T, Y>):String
	{
		return map.toString();
	}
}