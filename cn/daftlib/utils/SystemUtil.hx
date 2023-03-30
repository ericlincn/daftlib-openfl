package cn.daftlib.utils;
import openfl.system.System;

/**
 * ...
 * @author eric.lin
 */
@:final class SystemUtil
{
	public static function gc():Void
	{
		System.gc();
	}	
}