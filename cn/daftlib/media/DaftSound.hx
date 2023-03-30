package cn.daftlib.media;
import cn.daftlib.core.RemovableEventDispatcher;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.ID3Info;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.net.URLRequest;

/**
 * ...
 * @author eric.lin
 */
/*[Event(name = "soundComplete", type = "flash.events.Event")]
[Event(name = "id3", type = "flash.events.Event")]
[Event(name = "complete", type = "flash.events.Event")]*/
 
@:final class DaftSound extends RemovableEventDispatcher implements IMedia
{
	private var __sound:Sound;
	private var __channel:SoundChannel;

	private var __volume:Float = 1;
	private var __pan:Float = 0;
	private var __loop:Bool = true;
	
	private var __paused:Bool = false;
	private var __pausedTime:Float = 0;
	private var __id3:ID3Info = null;
	
	public var id3(get, null):ID3Info;
	
	public var source(null, set):String;
	public var loop(null, set):Bool;
	public var volume(null, set):Float;
	public var pan(null, set):Float;
	public var playingTime(get, set):Float;
	public var totalTime(get, null):Int;
	public var playingPercent(get, null):Float;
	public var loadingPercent(get, null):Float;

	public function new()
	{
		super(null);
	}

	override public function destroy():Void
	{
		super.destroy();

		clearChannel();
		clearSound();
	}
	private function get_id3():ID3Info
	{
		return __id3;
	}
	private function set_source(url:String):String
	{
		__id3 = null;

		clearChannel();
		clearSound();

		if(url == null)
			return null;

		__sound = new Sound();
		__sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		__sound.addEventListener(Event.ID3, id3Handler);
		__sound.addEventListener(Event.COMPLETE, completeHandler);
		__sound.load(new URLRequest(url));

		playSound();
		
		return url;
	}
	private function set_loop(value:Bool):Bool
	{
		__loop = value;
		
		return __loop;
	}
	private function set_volume(value:Float):Float
	{
		__volume = Math.max(0.0, Math.min(1.0, value));

		applyTransform();
		
		return __volume;
	}
	private function set_pan(value:Float):Float
	{
		__pan = Math.max(-1.0, Math.min(1.0, value));

		applyTransform();
		
		return __pan;
	}
	private function set_playingTime(ms:Float):Float
	{
		playSound(ms);
		
		return ms;
	}
	private function get_totalTime():Int
	{
		if(__sound == null)
			return 0;

		if(loadingPercent == 0)
			return 0;

		return Math.ceil(__sound.length / loadingPercent);
	}
	private function get_playingTime():Float
	{
		if(__channel == null)
			return 0;

		return __channel.position;
	}
	private function get_playingPercent():Float
	{
		if(totalTime != 0)
			return playingTime / totalTime;

		return 0;
	}
	private function get_loadingPercent():Float
	{
		if(__sound == null)
			return 0;

		return __sound.bytesLoaded / __sound.bytesTotal;
	}
	public function pause():Void
	{
		if(__channel != null)
		{
			__pausedTime = __channel.position;
			__channel.stop();
			__paused = true;
		}
	}
	public function resume():Void
	{
		if(__paused == true)
		{
			__paused = false;
			playSound(__pausedTime);
		}
	}

	/**
	 * start play
	 */
	private function playSound(startTime:Float = 0):Void
	{
		if(__paused == true)
			return;
		if(__sound == null)
			return;

		clearChannel();
		
		__channel = __sound.play(startTime, 1);
		__channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);

		applyTransform();
	}
	private function applyTransform():Void
	{
		if(__channel != null)
		{
			var transform:SoundTransform = __channel.soundTransform;
			transform.volume = __volume;
			transform.pan = __pan;
			__channel.soundTransform = transform;
		}
	}
	private function clearChannel():Void
	{
		if(__channel != null)
		{
			__channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			__channel.stop();
			__channel = null;
		}
	}
	private function clearSound():Void
	{
		if(__sound != null)
		{
			//__sound.close();
			__sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			__sound.removeEventListener(Event.ID3, id3Handler);
			__sound.removeEventListener(Event.COMPLETE, completeHandler);
			__sound = null;
		}
	}
	private function soundCompleteHandler(e:Event):Void
	{
		this.dispatchEvent(new Event(Event.SOUND_COMPLETE));

		if(__loop == true)
			playSound();
	}
	private function id3Handler(e:Event):Void
	{
		__id3 = __sound.id3;
		
		/*__id3 = new ID3Info();

		__id3.album = encodeUTF8(__sound.id3.album);
		__id3.artist = encodeUTF8(__sound.id3.artist);
		__id3.comment = encodeUTF8(__sound.id3.comment);
		__id3.genre = encodeUTF8(__sound.id3.genre);
		__id3.songName = encodeUTF8(__sound.id3.songName);
		__id3.track = encodeUTF8(__sound.id3.track);
		__id3.year = encodeUTF8(__sound.id3.year);*/

		this.dispatchEvent(e);
	}
	private function completeHandler(e:Event):Void
	{
		this.dispatchEvent(e);
	}
	private function ioErrorHandler(e:IOErrorEvent):Void
	{
		trace(this, e);
	}
}