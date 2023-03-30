package cn.daftlib.utils;

/**
 * ...
 * @author eric.lin
 */
@:final class FlashVarUtil
{
	public static function getValue(key:String):String
	{
		return Reflect.field(StageReference.stage.loaderInfo.parameters, key);
	}
	public static function hasKey(key:String):Bool
	{
		return FlashVarUtil.getValue(key) != null ? true : false;
	}
}