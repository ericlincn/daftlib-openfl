package cn.daftlib.utils;

/**
 * ...
 * @author eric.lin
 */
@:final class StringUtil
{	
	/**
	 * 是否是Email
	 * @param email
	 * @return
	 */
	public static function isEmail(source:String):Bool
	{
		var pattern:EReg = ~/^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
		return pattern.match(source);
	}
	
	/**
	 * 是否是数字
	 * @param char
	 * @return
	 */
	public static function isNumber(source:String):Bool
	{
		return !Math.isNaN(Std.parseFloat(source));
	}
	
	/**
	 * 去左右空格
	 * @param char
	 * @return
	 */
	public static function trim(source:String):String
	{
		return StringTools.trim(source);
	}
	
	/**
	 * 去左空格
	 * @param char
	 * @return
	 */
	public static function ltrim(source:String):String
	{
		return StringTools.ltrim(source);
	}
	
	/**
	 * 去右空格
	 * @param char
	 * @return
	 */
	public static function rtrim(source:String):String
	{
		return StringTools.rtrim(source);
	}
	
	/**
	 * 字符串首字母大写，其余字母小写
	 * @param original
	 * @return
	 */
	public static function initialCap(source:String):String
	{
		return source.charAt(0).toUpperCase() + source.substr(1).toLowerCase();
	}
	
	/**
	 * Removes tabs, linefeeds, carriage returns and spaces from String.
	 * @param source
	 * @return
	 */
	public static function removeWhitespace(source:String):String
	{
		var pattern:EReg = new EReg('[ \n\t\r]', 'g');
		return pattern.replace(source, '');
	}
	
	/**
	 * 取得字符串中的数字
	 * @param source
	 * @return
	 */
	public static function getNumbersFromString(source:String):String
	{
		var pattern:EReg = ~/[^0-9]/g;
		return pattern.replace(source, '');
	}
	
	/**
	 * 取得字符串中的字母
	 * @param source
	 * @return
	 */
	public static function getLettersFromString(source:String):String
	{
		var pattern:EReg = ~/[^A-Z^a-z]/g;
		return pattern.replace(source, '');
	}
	
	/**
	 * Replaces target characters with new characters.
	 * @param source
	 * @param remove
	 * @param replace
	 * @return
	 */
	public static function replace(source:String, remove:String, replace:String):String
	{
		var pattern:EReg = new EReg(remove, 'g');
		return pattern.replace(source, replace);
	}
	
	/**
	 * 替换字符串模板
	 *
	 * var str:String = "Hei jave, there are {0} apples，and {1} banana！ {2} dollar all together";
	 * trace(StringUtil.substitute(str, 5, 10, 20));
	 *
	 * @param str
	 * @param rest
	 * @return
	 */
	public static function substitute(source:String, params:Array<Dynamic>):String
	{
		for(i in 0 ... params.length)
		{
			var pattern:EReg = new EReg("\\{" + i + "\\}", 'g');
			source = pattern.replace(source, params[i]);
		}

		return source;
	}
	
	/**
	 * 以属性名方式替换字符串模板
	 *
	 * var str:String = "{call}这是{structname}结构代换你的懂。";
	 * trace(StringUtil.substituteProperty(str, {call:"哥，", structname:"k,v数据"}));
	 *
	 * @param str
	 * @param obj
	 * @return
	 */
	public static function substituteProperty(source:String, obj:Dynamic):String
	{
		for(key in Reflect.fields(obj))
		{
			var pattern:EReg = new EReg("\\{" + key + "\\}", 'gm');
			source = pattern.replace(source, ReflectUtil.getField(obj, key));
		}

		return source;
	}
	
	/**
	 * 去掉文件名中的扩展名
	 * @param $fileName
	 * @return
	 */
	public static function removeExtension(source:String):String
	{
		// Find the location of the period.
		var extensionIndex:Int = source.lastIndexOf('.');
		if(extensionIndex == -1)
		{
			// Oops, there is no period. Just return the $fileName.
			return source;
		}
		else
		{
			return source.substr(0, extensionIndex);
		}
	}

	/**
	 * 只取得文件名中的扩展名
	 * @param $fileName
	 * @return
	 */
	public static function getExtension(source:String):String
	{
		// Find the location of the period.
		var extensionIndex:Int = source.lastIndexOf('.');
		if(extensionIndex == -1)
		{
			// Oops, there is no period, so return the empty string.
			return null;
		}
		else
		{
			return source.substr(extensionIndex + 1, source.length).toLowerCase();
		}
	}
	
	/**
	 * 随机字符串(不保证唯一)
	 * @param $length
	 * @return
	 */
	public static function getRandomString(len:Int):String
	{
		var chars:String = "ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678"; // 默认去掉了容易混淆的字符oOLl,9gq,Vv,Uu,I1
		var maxPos:Int = chars.length;
		var out:String = "";
		var i:Int = len;
		while(i-->0)
		{
			out += chars.charAt(Math.floor(Math.random() * maxPos));
		}
		return out;
	}
	
	/**
	 * 字符串是否含有中文
	 *
	 * <listing version="3.0">
	 * trace(StringUtil.containsChinese("き"), StringUtil.containsNonEnglish("き"));
	 * trace(StringUtil.containsChinese("test,.?!%^&*(){}[]"), StringUtil.containsNonEnglish("test,.?!%^&*(){}[]"));
	 * trace(StringUtil.containsChinese("测试"), StringUtil.containsNonEnglish("测试"));
	 * trace(StringUtil.containsChinese("“测试”，。？！%……&*（）——{}【】”"), StringUtil.containsNonEnglish("“测试”，。？！%……&*（）——{}【】”"));
	 * trace(StringUtil.containsChinese("ＡＢab"), StringUtil.containsNonEnglish("ＡＢab"));
	 *
	 * 输出:
	 *
	 * false true
	 * false false
	 * true true
	 * true true
	 * false true
	 * </listing>
	 *
	 * @param $str
	 * @return
	 */
	public static function containsChinese(source:String):Bool
	{
		var i:Int = 0;
		while(i < source.length)
		{
			var code:Int = source.charCodeAt(i);
			if((code >= 0x4e00) && (code <= 0x9fbb))
			{
				return true;
			}
			i++;
		}
		return false;
	}
	/**
	 * 字符串是否含有非英文字符
	 * @param $str
	 * @return
	 */
	public static function containsNonEnglish(source:String):Bool
	{
		var i:Int = 0;
		while(i < source.length)
		{
			var code:Int = source.charCodeAt(i);
			if(code > 255 || code < 0)
			{
				return true;
			}
			i++;
		}
		return false;
	}
	
	public static function getFormattedNumber(value:Float):String
	{
		if(Math.isNaN(value))
			return "NaN";
		if(value == Math.POSITIVE_INFINITY)
			return "Infinity";
		if(value == Math.NEGATIVE_INFINITY)
			return "-Infinity";

		var thousandsSeparator:String = ",";
		var decimalSeparator:String = ".";
		var str:String = "" + value;
		//	convert num to string for formatting
		//  we split it at the decimal point first
		var pieces:Array<String> = str.split('.');
		var before:Array<String> = pieces[0].split('');
		var after:String = pieces[1] != null ? pieces[1] : '';

		// add thousands separator			
		var len:Int = before.length;
		var before_formatted:Array<String> = [];
		for(i in 0 ... len)
		{
			if(i % 3 == 0 && i != 0)
				before_formatted.unshift(thousandsSeparator);
			before_formatted.unshift(before[len - 1 - i]);
		}

		var result:String = before_formatted.join('');
		if(after.length > 0)
			result += decimalSeparator + after;

		return result;
	}
}