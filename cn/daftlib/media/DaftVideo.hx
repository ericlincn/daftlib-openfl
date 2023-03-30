package cn.daftlib.media;

import cn.daftlib.core.IDestroyable;
import cn.daftlib.core.IRemovableEventDispatcher;
import cn.daftlib.core.ListenerManager;
import cn.daftlib.events.VideoEvent;
import openfl.events.NetStatusEvent;
import openfl.events.SecurityErrorEvent;
import openfl.media.SoundTransform;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

/**
 * ...
 * @author eric.lin
 */
@:noCompletion @:final class DaftVideo extends Video implements IDestroyable implements IRemovableEventDispatcher implements IMedia
{
	private var __nc:NetConnection;
	private var __ns:NetStream;
	
	private var __volume:Float = 1;
	private var __pan:Float = 0;
	private var __loop:Bool = false;
	private var __totalTime:Int = 0;
	
	public var source(null, set):String;
	public var loop(null, set):Bool;
	public var volume(null, set):Float;
	public var pan(null, set):Float;
	public var playingTime(get, set):Float;
	public var totalTime(get, null):Int;
	public var playingPercent(get, null):Float;
	public var loadingPercent(get, null):Float;
	
	public function new(width:Int=320, height:Int=240) 
	{
		super(width, height);
		
		initConnection();
	}
	
	override public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void
	{
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		ListenerManager.registerEventListener(this, type, listener, useCapture);
	}
	override public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void
	{
		super.removeEventListener(type, listener, useCapture);
		ListenerManager.unregisterEventListener(this, type, listener, useCapture);
	}
	public function removeEventsForType(type:String):Void
	{
		ListenerManager.removeEventsForType(this, type);
	}
	public function removeEventsForListener(listene:Dynamic->Void):Void
	{
		ListenerManager.removeEventsForListener(this, listene);
	}
	public function removeEventListeners():Void
	{
		ListenerManager.removeEventListeners(this);
	}
	
	#if !flash
	override function set_x(value:Float):Float
	{
		return super.x = Math.round(value);
	}
	override function set_y(value:Float):Float
	{
		return super.y = Math.round(value);
	}
	#end
	
	public function destroy():Void
	{
		clearConnection();
		clearStream();

		this.clear();

		this.removeEventListeners();

		if(this.parent != null)
			this.parent.removeChild(this);
	}

	private function set_source(url:String):String
	{
		clearStream();
		
		this.clear();

		if(url == null)
			return null;

		__ns = new NetStream(__nc);
		__ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		__ns.client = getClient();
		__ns.play(url);

		applyTransform();
		
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
		ms = ms / 1000;

		if(__ns != null)
			__ns.seek(Math.round(ms * 100) / 100);
			
		return ms;
	}
	private function get_totalTime():Int
	{
		return __totalTime;
	}
	private function get_playingTime():Float
	{
		if(__ns != null)
			return __ns.time * 1000;

		return 0;
	}
	private function get_playingPercent():Float
	{
		if(__totalTime != 0)
			return playingTime / __totalTime;

		return 0;
	}
	private function get_loadingPercent():Float
	{
		if(__ns != null)
			return __ns.bytesLoaded / __ns.bytesTotal;

		return 0;
	}
	public function pause():Void
	{
		if(__ns != null)
			__ns.pause();
	}
	public function resume():Void
	{
		if(__ns != null)
			__ns.resume();
	}

	/**
	 * volume related
	 */
	private function applyTransform():Void
	{
		if(__ns != null)
		{
			var transform:SoundTransform = __ns.soundTransform;
			if (transform != null)
			{
				transform.volume = __volume;
				transform.pan = __pan;
				__ns.soundTransform = transform;
			}
		}
	}
	/**
	 * Initialize related
	 */
	private function initConnection():Void
	{
		__nc = new NetConnection();
		__nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		__nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		__nc.connect(null);
	}
	private function netStatusHandler(event:NetStatusEvent):Void
	{
		//trace("NetStatusEvent.info.code:	"+event.info.code);

		switch(event.info.code)
		{
			case "NetStream.Play.StreamNotFound":
				trace(this, "Stream not found");
			case "NetStream.Play.Start":
				this.attachNetStream(__ns);
				this.dispatchEvent(new VideoEvent(VideoEvent.START));
			case "NetStream.Play.Stop":
				this.dispatchEvent(new VideoEvent(VideoEvent.STOP));
				if(__loop == true)
					playingTime = 0;
			case "NetStream.Buffer.Empty":
				this.dispatchEvent(new VideoEvent(VideoEvent.BUFFER_EMPTY));
			case "NetStream.Buffer.Full":
				this.dispatchEvent(new VideoEvent(VideoEvent.BUFFER_FULL));
		}
	}
	private function securityErrorHandler(event:SecurityErrorEvent):Void
	{
		trace(this, event);
	}
	private function clearStream():Void
	{
		if(__ns != null)
		{
			__ns.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			__ns.close();
			__ns = null;
		}
	}
	private function clearConnection():Void
	{
		__nc.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		__nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	}

	/**
	 * Meta related
	 */
	private function getClient():Dynamic
	{
		var client:Dynamic = {};
		client.onMetaData = this.onMetaData;
		client.onCuePoint = this.onCuePoint;
		client.onXMPData = this.onXMPData;

		return client;
	}
	private function onMetaData(info:Dynamic):Void
	{
		//trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
		var totalTime:Float = (info.duration);
		var frameRate:Int = (info.framerate);

		__totalTime = Std.int(totalTime * 1000);

		var event:VideoEvent = new VideoEvent(VideoEvent.META_DATA);
		event.duration = (info.duration);
		event.framerate = (info.framerate);
		event.width = (info.width);
		event.height = (info.height);

		this.dispatchEvent(event);
	}
	private function onCuePoint(info:Dynamic):Void{}
	private function onXMPData(info:Dynamic):Void{}
}