package cn.daftlib.utils;
import openfl.utils.ByteArray;

/**
 * ...
 * @author eric.lin
 */
@:final class SoundUtil
{
	public static var SILENT_SOUND_BASE64(get, null):String;
	
	/*
	 * usage:
	 * var b:ByteArray = bytesToByteArray(Base64.decode(SoundUtil.SILENT_SOUND_BASE64));
	 * b.position = 0;
	 * var snd:Sound = new Sound();
	 * snd.loadCompressedDataFromByteArray(b, b.length);
	 * snd.play();
	 */
	private static function get_SILENT_SOUND_BASE64():String
	{
		var str:String = "UklGRooWAABXQVZFZm10IBAAAAABAAEAIlYAAESsAAACABAAZGF0YWYW";
		var i:Int = str.length;
		while(i<7704)
		{
			str += "A";
			i++;
		}
		
		return str;
	}
	
	public static function convert32bitAudioStreamTo16bit(bytes:ByteArray, volume:Float = 1):ByteArray
	{
		var ba:ByteArray = new ByteArray();

		bytes.position = 0;
		while(bytes.bytesAvailable > 0)
		{
			ba.writeShort(Std.int(bytes.readFloat() * (0x7fff * volume)));
		}

		return ba;
	}
}