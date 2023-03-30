package cn.daftlib.errors;

import openfl.errors.Error;

/**
 * ...
 * @author eric.lin
 */
@:final class DuplicateDefinedError extends Error
{
	public function new(referenceType:String = null, message:String = "", id:Int = 0) 
	{
		super((referenceType == null) ? 'The property should only be defined once, and its has been defined.' : 'Property class: "' + referenceType + '" should only be defined once, and its has been defined.');
	}
}