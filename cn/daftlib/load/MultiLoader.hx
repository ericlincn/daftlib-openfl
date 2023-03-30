package cn.daftlib.load;

import cn.daftlib.core.RemovableEventDispatcher;
import cn.daftlib.errors.InvalidTypeError;
import cn.daftlib.events.LoadEvent;
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.IEventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.system.LoaderContext;

/**
 * ...
 * @author eric.lin
 */
/*[Event(name = "start", 			type = "cn.daftlib.events.LoadEvent")]
[Event(name = "progress", 		type = "cn.daftlib.events.LoadEvent")]
[Event(name = "complete", 		type = "cn.daftlib.events.LoadEvent")]
[Event(name = "itemComplete", 	type = "cn.daftlib.events.LoadEvent")]*/
 
private typedef LoadingItem = { request:URLRequest, type:Dynamic, 
								context:LoaderContext, bytesTotal:Float};

@:final class MultiLoader extends RemovableEventDispatcher
{
	private var IMAGE_EXTENSIONS:Array<String> = ["swf", "jpg", "jpeg", "gif", "png"];
	private var TEXT_EXTENSIONS:Array<String> = ["txt", "js", "xml", "php", "asp", "aspx"];
	
	public static var IMAGE:String = "image";
	public static var TEXT:URLLoaderDataFormat  = URLLoaderDataFormat.TEXT;
	public static var BINARY:URLLoaderDataFormat  = URLLoaderDataFormat.BINARY;
	public static var VARIABLES:URLLoaderDataFormat  = URLLoaderDataFormat.VARIABLES;
	 
	private var __loaded:Map<String, Dynamic>;
	private var __itemsLoaded:Int;
	private var __items:Array<LoadingItem>;

	private var __currentDispatcher:IEventDispatcher;
	
	public function new()
	{
		super(null);

		clear();
	}

	public function add(url:String, type:Dynamic = null, context:LoaderContext = null, bytesTotal:Float = 0):Void
	{
		var loadingItem:LoadingItem = { request:null, type:null, context:null, bytesTotal:0 };
		loadingItem.request = new URLRequest(url);

		if(context != null)
			loadingItem.context = context;
		if(type != null)
			loadingItem.type = type;

		loadingItem.bytesTotal = bytesTotal;

		if(loadingItem.type == null)
			loadingItem.type = getType(url);

		__items.push(loadingItem);
	}

	public function start():Void
	{
		if(__items.length <= 0)
			throw new Error('Non loading task has been added.');

		__itemsLoaded = 0;
		load(__itemsLoaded);

		this.dispatchEvent(new LoadEvent(LoadEvent.START));
	}

	public function get(key:String):Dynamic
	{
		if(__loaded[key] != null)
		{
			return __loaded[key];
		}

		return null;
	}

	public function clear():Void
	{
		if(this.hasEventListener(LoadEvent.COMPLETE))
			this.removeEventsForType(LoadEvent.COMPLETE);

		if(__currentDispatcher != null)
		{
			__currentDispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			__currentDispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			__currentDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			__currentDispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			__currentDispatcher = null;
		}

		__loaded = new Map<String, IEventDispatcher>();
		__items = [];
	}
	override public function destroy():Void
	{
		clear();

		super.destroy();
	}

	private function loadImage(url:URLRequest, context:LoaderContext):Void
	{
		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
		loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		try
		{
			loader.load(url, context);
		}
		catch(err:Error)
		{
			trace(this, err);
		}

		__currentDispatcher = loader.contentLoaderInfo;
	}
	private function loadText(url:URLRequest, type:URLLoaderDataFormat):Void
	{
		var loader:URLLoader = new URLLoader();
		loader.dataFormat=type;
		loader.addEventListener(Event.COMPLETE, completeHandler);
		loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		try
		{
			loader.load(url);
		}
		catch(err:Error)
		{
			trace(this, err);
		}

		__currentDispatcher = loader;
	}
	private function completeHandler(e:Event):Void
	{
		cast(e.target, IEventDispatcher).removeEventListener(Event.COMPLETE, completeHandler);
		cast(e.target, IEventDispatcher).removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		cast(e.target, IEventDispatcher).removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		cast(e.target, IEventDispatcher).removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);

		var item:LoadingItem = __items[__itemsLoaded];
		if(Std.is(e.target, LoaderInfo))
			__loaded[item.request.url]=cast(e.target, LoaderInfo).content;
		else if(Std.is(e.target, URLLoader))
			__loaded[item.request.url]=cast(e.target, URLLoader).data;
		
		var event:LoadEvent = new LoadEvent(LoadEvent.ITEM_COMPLETE);
		event.url = item.request.url;
		this.dispatchEvent(event);

		__itemsLoaded++;
		if(__itemsLoaded >= __items.length)
		{
			this.dispatchEvent(new LoadEvent(LoadEvent.COMPLETE));
			__currentDispatcher = null;
		}
		else
			load(__itemsLoaded);
	}
	private function progressHandler(e:ProgressEvent):Void
	{
		var singlePercent:Float = e.bytesLoaded / e.bytesTotal;
		var item:LoadingItem = __items[__itemsLoaded];

		if(e.bytesTotal <= 0)
		{
			if(item.bytesTotal != 0)
				singlePercent = e.bytesLoaded / item.bytesTotal;
			else
				singlePercent = 1;
		}

		var percentLoaded:Float = singlePercent + __itemsLoaded;
		var percentTotal:Int = __items.length;
		var event:LoadEvent = new LoadEvent(LoadEvent.PROGRESS);
		event.url = item.request.url;
		event.percent = percentLoaded / percentTotal;
		event.itemsLoaded = __itemsLoaded;
		event.itemsTotal = __items.length;
		this.dispatchEvent(event);
	}
	private function ioErrorHandler(e:IOErrorEvent):Void
	{
		//throw e;
		trace(this, e);
	}
	private function securityErrorHandler(e:SecurityErrorEvent):Void
	{
		//throw e;
		trace(this, e);
	}
	private function load(index:Int):Void
	{
		var item:LoadingItem = __items[index];

		if(item.type == IMAGE)
			loadImage(item.request, item.context);
		else if(item.type == TEXT || item.type == BINARY || item.type == VARIABLES)
			loadText(item.request, item.type);
	}
	private function getType(url:String):Dynamic
	{
		var i:Int;
		var extension:String = "";
		var n:Int;
		var result:Dynamic = null;

		i = 0;
		n = IMAGE_EXTENSIONS.length;

		while(i < n)
		{
			extension = IMAGE_EXTENSIONS[i];
			if(extension == url.substr(-extension.length).toLowerCase())
			{
				result = IMAGE;
				break;
			}

			i++;
		}

		if(result != null)
			return result;

		i = 0;
		n = TEXT_EXTENSIONS.length;
		while(i < n)
		{
			extension = TEXT_EXTENSIONS[i];
			if(extension == url.substr(-extension.length).toLowerCase())
			{
				result = TEXT;
				break;
			}

			i++;
		}

		if(result != null)
			return result;
		else
			throw new InvalidTypeError(url.substr(-extension.length).toLowerCase());
			
		return null;
	}
}