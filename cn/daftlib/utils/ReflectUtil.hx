package cn.daftlib.utils;

/**
 * ...
 * @author eric.lin
 */
@:final class ReflectUtil
{
	inline public static function hasField (target:Dynamic, propertyName:String):Bool
	{
		var value:Bool = Reflect.hasField (target, propertyName) #if flash && !untyped (target).hasOwnProperty ("set_" + propertyName) #elseif html5 && !(untyped (target).__properties__ && untyped (target).__properties__["set_" + propertyName]) #end;
		
		if (Reflect.getProperty (target, propertyName) != null)
			value = true;
		else if (Reflect.field (target, propertyName) != null)
			value = true;
		
		return value;
	}
	inline public static function getField (target:Dynamic, propertyName:String):Dynamic
	{
		#if (haxe_209 || haxe3)
		var value = null;
		
		if (Reflect.hasField (target, propertyName))
		{
			#if flash
			value = untyped target[propertyName];
			#else
			value = Reflect.field (target, propertyName);
			#end
		} 
		else 
		{
			value = Reflect.getProperty (target, propertyName);
		}
		
		return value;
		
		#else
		return Reflect.field (target, propertyName);
		#end
	}
	inline public static function setField (target:Dynamic, propertyName:String, value:Dynamic):Void
	{
		if (Reflect.hasField (target, propertyName))
		{
			#if flash
			untyped target[propertyName] = value;
			#else
			Reflect.setField (target, propertyName, value);
			#end
		} 
		else 
		{
			#if (haxe_209 || haxe3)
			Reflect.setProperty (target, propertyName, value);
			#end
		}
	}
}