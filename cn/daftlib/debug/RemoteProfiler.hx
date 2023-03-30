package cn.daftlib.debug;
import cn.daftlib.errors.DuplicateDefinedError;
import cn.daftlib.errors.UndefinedError;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;
import openfl.events.TimerEvent;
import openfl.Lib;
import openfl.net.Socket;
import openfl.utils.Timer;

/**
 * ...
 * @author eric.lin
 */
@:final class RemoteProfiler
{
	private static var __socket:Socket;
	private static var __msgArr:Array<String> = [];
	private static var __timer:Timer;
	
	public static function initialize(host:String = "127.0.0.1", port:Int = 22222):Void
	{
		if(__socket != null)
			throw new DuplicateDefinedError(__socket.toString());
			
		__socket = new Socket();
		__socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		__socket.addEventListener(Event.CONNECT, connectHandler);
		__socket.addEventListener(Event.CLOSE, closeHandler);
		__socket.addEventListener(ProgressEvent.SOCKET_DATA, dataHandler);
		__socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		__socket.connect(host, port);
	}
	public static function log(param1:Dynamic, param2:Dynamic = null, param3:Dynamic = null, param4:Dynamic = null, param5:Dynamic = null):Void
	{
		trace("[Class RemoteProfiler].log() may has bug.");
		
		if (__socket == null)
			throw new UndefinedError("[class Socket]");

		var msg:String = "";
		if (param5 != null)
		{
			msg += (param1 + ",");
			msg += (param2 + ",");
			msg += (param3 + ",");
			msg += (param4 + ",");
			msg += (param5 + "");
		}
		else if (param4 != null)
		{
			msg += (param1 + ",");
			msg += (param2 + ",");
			msg += (param3 + ",");
			msg += (param4 + "");
		}
		else if (param3 != null)
		{
			msg += (param1 + ",");
			msg += (param2 + ",");
			msg += (param3 + "");
		}
		else if (param2 != null)
		{
			msg += (param1 + ",");
			msg += (param2 + "");
		}
		else
			msg += (param1 + "");
			
		//msg += Std.string(Lib.getTimer());
		
		if (__socket.connected == false || !__socket.connected)
		{
			if (__timer == null)
			{
				__timer = new Timer(1000 / 60, 0);
				__timer.addEventListener(TimerEvent.TIMER, timerHandelr);
				__timer.start();
			}
			__msgArr.push(msg);
		}
		else if (__socket.connected == true)
		{
			send(msg);
		}
	}
	private static function timerHandelr(e:TimerEvent):Void
	{
		if (__socket.connected == true)
		{
			var i:Int = 0;
			while(i<__msgArr.length)
			{
				send(__msgArr[i]);
				
				i++;
			}
			
			__msgArr = null;
			__timer.removeEventListener(TimerEvent.TIMER, timerHandelr);
			__timer.stop();
			__timer = null;
		}
	}
	private static function send(msg:String):Void
	{
		__socket.writeUTFBytes(msg);
		__socket.flush();
	}
	private static function ioErrorHandler(e:IOErrorEvent):Void
	{
		trace(e.toString());
	}
	private static function connectHandler(e:Event):Void
	{
		trace(e.toString());
	}
	private static function closeHandler(e:Event):Void
	{
		trace(e.toString());
	}
	private static function securityErrorHandler(e:SecurityErrorEvent):Void
	{
		trace(e.toString());
	}
	private static function dataHandler(e:ProgressEvent):Void
	{
		trace(__socket.readUTF());
	}
}