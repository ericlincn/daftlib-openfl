package cn.daftlib.errors;

import openfl.errors.Error;

/**
 * ...
 * @author eric.lin
 */
@:final class UndefinedError extends Error
{
	public function new(referenceType:String = null, message:String = "", id:Int = 0) 
	{
		super((referenceType == null) ? 'The property is uninitialized or undefined.' : 'Property class: "' + referenceType + '" is uninitialized or undefined.');
	}
}