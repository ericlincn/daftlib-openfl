package cn.daftlib.data ;

/**
 * ...
 * @author eric.lin
 */
abstract DynamicObject({}) from {}
{
	@:arrayAccess public inline function arrayAccess(key:String):Dynamic
	{
        return Reflect.field(this, key);
    }
    @:arrayAccess public inline function arrayWrite<T>(key:String, value:T):T
	{
        Reflect.setField(this, key, value);
        return value;
    }
}