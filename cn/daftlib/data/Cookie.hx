package cn.daftlib.data;
import cn.daftlib.utils.ReflectUtil;
import openfl.errors.Error;
import openfl.net.SharedObject;
import openfl.net.SharedObjectFlushStatus;

/**
 * ...
 * @author eric.lin
 */
@:final class Cookie
{
	private var UPDATE_TIME:String = "updateTime";
	
	private var __name:String;
	
	public function new(name:String)
	{
		__name = name;
	}
	public function setValue(key:String, data:Dynamic):Void
	{
		if(key == UPDATE_TIME)
			throw new Error('$key couldnt be "updateTime".');

		var so:SharedObject = SharedObject.getLocal(__name, "/");
		tryToSetValue(so, key, data);
		tryToFlush(so);
	}
	public function getValue(key:String):Dynamic
	{
		var so:SharedObject = SharedObject.getLocal(__name, "/");
		return isExist(so, key) ? ReflectUtil.getField(so.data, key) : null;
	}
	public function getUpdateTime():Dynamic
	{
		return getValue(UPDATE_TIME);
	}
	public function removeValue(key:String):Void
	{
		var so:SharedObject = SharedObject.getLocal(__name, "/");
		if(isExist(so, key))
		{
			//delete so.data[key];
			Reflect.deleteField(so.data, key);
			tryToFlush(so);
		}
	}
	public function printAllValue():String
	{
		var so:SharedObject = SharedObject.getLocal(__name, "/");
		var outStr:String = "";
		var n:Int = getKeyNumber(so.data);
		for(key in Reflect.fields(so.data))
		{
			try
			{
				outStr += key + ": " + ReflectUtil.getField(so.data, key);
				if(n > 1)
					outStr += "\n";
			}
			catch(e:Error)
			{
				trace(Cookie, e);
			}
			n--;
		}
		return outStr == "" ? null : outStr;
	}
	public function clear():Void
	{
		var so:SharedObject = SharedObject.getLocal(__name, "/");
		so.clear();
	}
	private function tryToSetValue(so:SharedObject, key:String, data:Dynamic):Void
	{
		try
		{
			//Reflect.setProperty(so.data, key, data);
			//Reflect.setProperty(so.data, UPDATE_TIME, Date.now());
			ReflectUtil.setField(so.data, key, data);
			ReflectUtil.setField(so.data, UPDATE_TIME, Date.now());
			//so.data[key] = data;
			//so.data[UPDATE_TIME] = new Date().getTime();
		}
		catch(e:Error)
		{
			trace(Cookie, e);
		}
	}
	private function isExist(so:SharedObject, key:String):Bool
	{
		try
		{
			//return so.data[key] != undefined;
			return ReflectUtil.getField(so.data, key) != null;
		}
		catch(e:Error)
		{
			trace(Cookie, e);
		}
		return false;
	}
	private function tryToFlush(so:SharedObject):Void
	{
		#if flash
		var flushStatus:String = null;
		#else
		var flushStatus:SharedObjectFlushStatus = null;
		#end
		
		try
		{
			flushStatus = so.flush();
		}
		catch(e:Error)
		{
			trace(Cookie, e);
		}

		if(flushStatus != null)
		{
			switch(flushStatus)
			{
				case SharedObjectFlushStatus.PENDING:
					//so.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
					trace("[Class Cookie]", "Flush pending.");
				case SharedObjectFlushStatus.FLUSHED:
					//trace("[Class Cookie]", "Flush success.");
			}
		}
	}
	private function getKeyNumber(object:Dynamic):Int
	{
		var n:Int = 0;
		for(key in Reflect.fields(object))
		{
			n++;
		}
		return n;
	}
	/*private static function onFlushStatus(e:NetStatusEvent):Void
	{
		trace(Cookie, e.info.code);
	}*/
}