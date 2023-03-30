package cn.daftlib.utils;
import openfl.errors.Error;

/**
 * ...
 * @author eric.lin
 */
class TimeUtil
{
	public static var MONTHS_EN:Array<String> = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	public static var DAYS_EN:Array<String> = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
	public static var MONTHS_CN:Array<String> = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"];
	public static var DAYS_CN:Array<String> = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"];
	
	/**
	 * Parses W3CDTF Time stamps eg 1994-11-05T13:15:30Z, 1997-07-16T19:20:30.45+01:00
	 * @param $str
	 * @return
	 */
	public static function parseW3CDTF(source:String):Date
	{
		var ignoreTimezone:Bool = false;
		var finalDate:Date = null;
		try
		{
			var dateStr:String = source.substring(0, source.indexOf("T"));
			var timeStr:String = source.substring(source.indexOf("T") + 1, source.length);
			var dateArr:Array<String> = dateStr.split("-");
			var year:Int = Std.parseInt(dateArr.shift());
			var month:Int = Std.parseInt(dateArr.shift());
			var date:Int = Std.parseInt(dateArr.shift());

			var multiplier:Int;
			var offsetHours:Int;
			var offsetMinutes:Int;
			var offsetStr:String;

			if(timeStr.indexOf("Z") != -1 || ignoreTimezone == true)
			{
				multiplier = 1;
				offsetHours = 0;
				offsetMinutes = 0;
				//timeStr = timeStr.replace("Z", "");
				timeStr = StringTools.replace(timeStr, "Z", "");
			}
			else if(timeStr.indexOf("+") != -1)
			{
				multiplier = 1;
				offsetStr = timeStr.substring(timeStr.indexOf("+") + 1, timeStr.length);
				offsetHours = Std.parseInt(offsetStr.substring(0, offsetStr.indexOf(":")));
				offsetMinutes = Std.parseInt(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
				timeStr = timeStr.substring(0, timeStr.indexOf("+"));
			}
			else
			{ // offset is -
				multiplier = -1;
				offsetStr = timeStr.substring(timeStr.indexOf("-") + 1, timeStr.length);
				offsetHours = Std.parseInt(offsetStr.substring(0, offsetStr.indexOf(":")));
				offsetMinutes = Std.parseInt(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
				timeStr = timeStr.substring(0, timeStr.indexOf("-"));
			}
			var timeArr:Array<String> = timeStr.split(":");
			var hour:Int = Std.parseInt(timeArr.shift());
			var minutes:Int = Std.parseInt(timeArr.shift());
			var secondsArr:Array<String> = (timeArr.length > 0) ? Std.string(timeArr.shift()).split(".") : null;
			var seconds:Int = (secondsArr != null && secondsArr.length > 0) ? Std.parseInt(secondsArr.shift()) : 0;
			var milliseconds:Int = (secondsArr != null && secondsArr.length > 0) ? Std.parseInt(secondsArr.shift()) : 0;

			if(ignoreTimezone == true)
			{
				finalDate = new Date(year, month - 1, date, hour, minutes, seconds);
			}
			else
			{
				//var utc:Float = DateTools.makeUtc(year, month - 1, date, hour, minutes, seconds);
				var offset:Float = (((offsetHours * 3600000) + (offsetMinutes * 60000)) * multiplier);
				//finalDate = new Date(utc - offset);
				finalDate = DateTools.delta(new Date(year, month - 1, date, hour, minutes, seconds), offset);
			}
			if(finalDate.toString() == "Invalid Date")
			{
				throw new Error("This date does not conform to W3CDTF.");
			}
		}
		catch(e:Error)
		{
			var eStr:String = "Unable to parse the string [" + source + "] into a date. ";
			eStr += "The internal error was: " + e.toString();
			trace('[TimeUtil] ' + eStr);
		}
		return finalDate;
	}
	/**
	 * Basic date formatting function
	 *
	 * getFormattedDate(date); // "Saturday, September 15, 2008 9:00pm"
	 * getFormattedDate(date, false, false, false); // "September 2009"
	 */
	public static function getFormattedDateEN(date:Date):String
	{
		var s:String = "";
		s += DAYS_EN[date.getDay()] + ", ";
		s += MONTHS_EN[date.getMonth()] + " ";
		s += date.getDate() + ", ";
		s += date.getFullYear();
		s += " " + getShortHour(date) + ":" + (date.getMinutes() < 10 ? "0" : "") + date.getMinutes() + getAMPM(date);
		return s;
	}
	public static function getFormattedDateCN(date:Date):String
	{
		var s:String = "";
		s += number2Chinese(date.getFullYear()) + "年, ";
		s += MONTHS_CN[date.getMonth()];
		s += number2Chinese(date.getDate()) + "日, ";
		s += DAYS_CN[date.getDay()] + ", ";
		s += (getAMPM(date) == "pm" ? "下午" : "上午") + number2Chinese(getShortHour(date)) + "点" + number2Chinese(date.getMinutes());
		return s;
	}

	/**
	 * Returns AM or PM for a given date
	 */
	public static function getAMPM(date:Date):String
	{
		return (date.getHours() > 11) ? "pm" : "am";
	}

	/**
	 * 将毫秒以 00:00:00 或 00:00 的形式格式化
	 * @param $ms
	 * @return
	 */
	public static function getClockTime(ms:Int, showHour:Bool = true):String
	{
		//var time:Date = Date.fromTime(ms);
		/*var time:Date = new Date(ms);
		var hours:int = time.getUTCHours();
		var minutes:int = time.getUTCMinutes();
		var seconds:int = time.getUTCSeconds();*/
		
		var onehour:Int = 1000 * 60 * 60;
		var oneminutes:Int = 1000 * 60;
		var oneseconds:Int = 1000;
		var hours:Int = Std.int(Math.floor(ms / onehour));
		ms -= hours * onehour;
		var minutes:Int = Std.int(Math.floor(ms / oneminutes));
		ms -= minutes * oneminutes;
		var seconds:Int = Std.int(Math.floor(ms / oneseconds));
		var timeStr:String;

		if(showHour == true)
			timeStr = fixNumber(hours) + ":" + fixNumber(minutes) + ":" + fixNumber(seconds);
		else
			timeStr = fixNumber(minutes) + ":" + fixNumber(seconds);

		return timeStr;
	}

	/**
	 * Convert framerate to time in ms, usually used for Timer class
	 * @param $frameRate
	 * @return
	 */
	public static function frameRateToTime(frameRate:Int):Int
	{
		return Std.int(1000 / frameRate);
	}

	/**
	 * 给不足2位的数字补0
	 * @param $num
	 * @return
	 */
	private static function fixNumber(num:Int):String
	{
		var addzero:String = Std.string(num + 100).substr(1, 2);
		return addzero;
	}
	private static function getShortHour(date:Date):Int
	{
		var h:Int = date.getHours();
		if(h == 0 || h == 12)
			return 12;
		else if(h > 12)
			return h - 12;
		else
			return h;
	}
	private static function number2Chinese(num:Int):String
	{
		var arr:Array<String> = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十"];

		var str:String = Std.string(num);

		if(num > 1000)
			return arr[Std.parseInt(str.charAt(0))] + arr[Std.parseInt(str.charAt(1))] + arr[Std.parseInt(str.charAt(2))] + arr[Std.parseInt(str.charAt(3))];
		if(num < 10)
			return arr[num];
		if(num < 100)
			return (Std.int(num / 10) > 1 ? arr[Std.int(num / 10)] : "十") + ((num % 10)!=0 ? arr[num % 10] : "十");
		return null;
	}
}