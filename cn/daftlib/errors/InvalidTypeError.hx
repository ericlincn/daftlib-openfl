package cn.daftlib.errors;

import openfl.errors.Error;

/**
 * ...
 * @author eric.lin
 */
@:final class InvalidTypeError extends Error
{
	public function new(type:String = null, message:String = "", id:Int = 0) 
	{
		super((type == null) ? 'The type is invalid or undefined.' : 'Type: "' + type + '" is invalid or undefined.');
	}
}