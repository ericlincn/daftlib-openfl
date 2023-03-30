package cn.daftlib.data;

import cn.daftlib.core.IDestroyable;
import openfl.errors.ArgumentError;

/**
 * ...
 * @author ...
 */
@:final class PaginatedArray implements IDestroyable
{
	private var __pageSize:Int = 1;
	private var __totalPages:Int;
	private var __currentPage:Int = 0;
	
	private var __array:Array<Dynamic>;
	
	public var pageSize(null, set):Int;
	public var totalPages(get, null):Int;
	public var currentPage(get, null):Int;
	
	public function new(array:Array<Dynamic> = null)
	{
		__array = (array == null)?[]:array.concat([]);
	}
	public function destroy():Void 
	{
		__array = null;
	}
	public function concat(a:Array<Dynamic>):Array<Dynamic>
	{
		__array = __array.concat(a);
		updateArrayLength();
		return __array;
	}
	public function push(x:Dynamic):Int
	{
		var length:Int = __array.push(x);
		updateArrayLength();
		return length;
	}
	public function pop():Null<Dynamic>
	{
		var out:Null<Dynamic> = __array.pop();
		updateArrayLength();
		return out;
	}
	public function shift():Null<Dynamic>
	{
		var out:Null<Dynamic> = __array.shift();
		updateArrayLength();
		return out;
	}
	public function splice(pos:Int, len:Int):Array<Dynamic>
	{
		var out:Array<Dynamic> = __array.splice(pos, len);
		updateArrayLength();
		return out;
	}
	public function unshift(x:Dynamic):Void
	{
		__array.unshift(x);
		updateArrayLength();
	}
	private function set_pageSize(value:Int):Int
	{
		if(value < 1)
		{
			throw new ArgumentError('$pageSize cant be less than 1.');
			return 0;
		}

		__pageSize = value;

		updateArrayLength();
		
		return __pageSize;
	}
	private function get_totalPages():Int
	{
		return __totalPages;
	}
	private function get_currentPage():Int
	{
		return __currentPage;
	}
	public function gotoPage(pageIndex:Int):Array<Dynamic>
	{
		if(pageIndex >= __totalPages)
		{
			throw new ArgumentError('$pageIndex should be less than totalPages.');
			return null;
		}
		__currentPage = pageIndex;

		var outArr:Array<Dynamic> = [];
		var startIndex:Int = __pageSize * __currentPage;
		var edgeIndex:Int = __pageSize * __currentPage + __pageSize;
		if(edgeIndex > __array.length)
			edgeIndex = __array.length;
		while(startIndex < edgeIndex)
		{
			outArr.push(__array[startIndex]);

			startIndex++;
		}
		return outArr;
	}
	public function gotoFirstPage():Array<Dynamic>
	{
		return gotoPage(0);
	}
	public function gotoLastPage():Array<Dynamic>
	{
		return gotoPage(__totalPages - 1);
	}
	public function gotoNextPage():Array<Dynamic>
	{
		if(__currentPage >= __totalPages - 1)
			return null;
		else
			return gotoPage(__currentPage + 1);
	}
	public function gotoPrevPage():Array<Dynamic>
	{
		if(__currentPage <= 0)
			return null;
		else
			return gotoPage(__currentPage - 1);
	}
	private function updateArrayLength():Void
	{
		__totalPages = Math.ceil(__array.length / __pageSize);
	}
}