package cn.daftlib.utils;
import cn.daftlib.data.DynamicDictionary;

/**
 * ...
 * @author eric.lin
 */
@:final class ArrayUtil
{
	/**
	 * Shuffle an Array.  This operation affects the array in place
	 * The shuffle algorithm used is a variation of the [Fisher Yates Shuffle](http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle)
	 * @param target
	 */	
	public static function shuffle<T>(target:Array<T>):Void
	{
		for(i in 0...target.length)
		{
			var j = Math.floor(target.length * Math.random());
			var a = target[i];
			var b = target[j];
			target[i] = b;
			target[j] = a;
		}
	}
	
	/**
	 * Quicksort, usage: ArrayUtil.quicksortByProperty(depthList, 0, depthList.length-1, "z");
	 * @param target
	 * @param lo
	 * @param hi
	 * @param propertyName
	 */	
	public static function quicksortByProperty<T>(target:Array<T>, lo:Int, hi:Int, propertyName:String):Void
	{
        var i:Int = lo;
        var j:Int = hi;
        var buf:Array<T> = target;
        //var p = buf[(lo + hi) >> 1].z;
		var p:Dynamic = ReflectUtil.getField(buf[(lo + hi) >> 1], propertyName);
		
        while( i <= j )
		{
            //while( arr[i].z > p ) i++;
            //while( arr[j].z < p ) j--;
			while( ReflectUtil.getField(target[i], propertyName) > p ) i++;
			while( ReflectUtil.getField(target[j], propertyName) < p ) j--;
            if( i <= j )
			{
                var t = buf[i];
                buf[i++] = buf[j];
                buf[j--] = t;
            }
        }
        if( lo < j ) quicksortByProperty(target, lo, j, propertyName);
        if( i < hi ) quicksortByProperty(target, i, hi, propertyName);
    }
	
	/**
	 * 交换数组元素位置
	 * @param $arr
	 * @param $indexA
	 * @param $indexB
	 */
	public static function switchElements<T>(target:Array<T>, indexA:Int, indexB:Int):Void
	{
		var a = target[indexA];
		var b = target[indexB];
		target.splice(indexA, 1);
		target.insert(indexA, b);
		target.splice(indexB, 1);
		target.insert(indexB, a);
	}
	
	/**
	 * 数组去重，不修改原数组，返回去重后的新数组
	 * @param target
	 * @return
	 */
	public static function distinct<T>(target:Array<T>):Array<T>
	{
		var res = [target[0]];
		for (i in 1...target.length)
		{
			#if js
			
			var repeat:Bool = false;
			for (j in 0...res.length)
			{
				if (target[i] == res[j])
				{
					repeat = true;
					break;
				}
			}
			if (repeat == false)
			{
				res.push(target[i]);
			}
			
			#else
			
			if(res.indexOf(target[i]) >= 0)
			{
				continue;
			}
			res.push(target[i]);
			
			#end
		}
		return res;
	}
	
	/**
	 * 取得某一长度的数组内，索引A，索引B之间的最短距离
	 * @param startIndex
	 * @param targetIndex
	 * @param length
	 * @return
	 */
	public static function getShortDistance(startIndex:Int, targetIndex:Int, length:Int):Int
	{
		var min:Float = NumberUtil.min(startIndex, targetIndex);
		var max:Float = NumberUtil.max(startIndex, targetIndex);
		
		if(max >= length)
			return 2147483647;

		var dist:Int = targetIndex - startIndex;
		if(NumberUtil.abs(dist) <= (length / 2))
			return dist;
		else
			return Std.int(-dist / NumberUtil.abs(dist) * (min + length - max));
	}
}