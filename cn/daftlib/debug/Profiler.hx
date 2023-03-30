package cn.daftlib.debug;
import cn.daftlib.errors.DuplicateDefinedError;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * ...
 * @author eric.lin
 */
@:final class Profiler
{
	public static var x(null, set):Float;
	public static var y(null, set):Float;
	
	private static var __stage:Stage;

	private static var __profiler:ProfilerContent;
	private static var __logger:Logger;
	//private static var __screenShotsBtn:TinyButton;
	//private static var __savelogBtn:TinyButton;
	private static var __minimizeBtn:TinyButton;
	private static var __maximizeBtn:TinyButton;

	private static var __scale:Float;
	private static var __x:Float;
	private static var __y:Float;
	
	public static function initialize(stage:Stage, scale:Float = 1):Void
	{
		if(__stage == null)
		{
			__scale = scale;

			__stage = stage;
			__profiler = new ProfilerContent(__stage);
			__stage.addChild(__profiler);

			__minimizeBtn = new TinyButton("-");
			__minimizeBtn.buttonMode = true;
			__minimizeBtn.addEventListener(MouseEvent.MOUSE_UP, minimize);
			__stage.addChild(__minimizeBtn);

			__maximizeBtn = new TinyButton("+");
			__maximizeBtn.buttonMode = true;
			__maximizeBtn.addEventListener(MouseEvent.MOUSE_UP, maximize);
			__stage.addChild(__maximizeBtn);

			__profiler.scaleX = __profiler.scaleY = __scale;
			__minimizeBtn.scaleX = __minimizeBtn.scaleY = __scale;
			__maximizeBtn.scaleX = __maximizeBtn.scaleY = __scale;

			x = y = 0;

			maximize(null);
		}
		else
			throw new DuplicateDefinedError(__stage.toString());
	}
	private static function set_x(x:Float):Float
	{
		if(__profiler == null)
			throw new Error('Please call "Profiler.initialize" first before set the position.');

		__x = Math.round(x);

		__profiler.x = __x;
		__minimizeBtn.x = __x + 107 * __scale;
		__maximizeBtn.x = __x + 107 * __scale;
		
		return __x;
	}
	private static function set_y(y:Float):Float
	{
		if(__profiler == null)
			throw new Error('Please call "Profiler.initialize" first before set the position.');

		__y = Math.round(y);

		__profiler.y = __y;
		__minimizeBtn.y = __y;
		__maximizeBtn.y = __y;
		
		return __y;
	}
	public static function log(param1:Dynamic, param2:Dynamic = null, param3:Dynamic = null, param4:Dynamic = null, param5:Dynamic = null):Void
	{
		trace("[Class Profiler].log() may has bug.");
		
		if(__profiler == null)
		{
			if(param5 != null)
				trace(param1, param2, param3, param4, param5);
			else if(param4 != null)
				trace(param1, param2, param3, param4);
			else if(param3 != null)
				trace(param1, param2, param3);
			else if(param2 != null)
				trace(param1, param2);
			else
				trace(param1);
			
			return;
		}

		if(__logger == null)
		{
			__logger = new Logger();
			__logger.y = 97 + 2;
			__profiler.addChild(__logger);
		}
		
		if (param5 != null)
			__logger.log(param1, param2, param3, param4, param5);
		else if (param4 != null)
			__logger.log(param1, param2, param3, param4);
		else if(param3 != null)
			__logger.log(param1, param2, param3);
		else if(param2 != null)
			__logger.log(param1, param2);
		else
			__logger.log(param1);
	}
	private static function maximize(e:MouseEvent):Void
	{
		__profiler.visible = /*__screenShotsBtn.visible = __savelogBtn.visible =*/ __minimizeBtn.visible = true;
		__maximizeBtn.visible = false;
	}
	private static function minimize(e:MouseEvent):Void
	{
		__profiler.visible =/* __screenShotsBtn.visible = __savelogBtn.visible =*/ __minimizeBtn.visible = false;
		__maximizeBtn.visible = true;
	}
}

private class ProfilerContent extends Sprite
{
	private var SIZE:Rectangle = new Rectangle(0, 0, 105, 97);
	private var GRAPH_SIZE:Rectangle = new Rectangle(0, 0, 90, 10);
	// Dynamic with Type
	// http://haxe.org/manual/types-dynamic-with-type-parameter.html
	private var COLORS:Dynamic<Int> = {fps:0xffffff, ms:0x999999, mem:0x01b0f0, memmax:0xaeee00};
	private var MARGIN:Int = 7;

	private var __stage:Stage;
	private var __graph:Bitmap;
	private var __memBm:Bitmap;

	private var __prevTime:Int = 0;
	private var __fps:Int = 0;
	private var __averageFps:Int = 0;
	private var __mem:Float = 0;
	private var __memMax:Float = 0;
	private var __ms:Int = 0;

	private var __rectClear:Rectangle;
	private var __rectDraw:Rectangle;
	private var __timeCount:Int = 0;
	private var __framesCount:Int = 0;
	
	private var __fpsArr:Array<Int> = [];
	private var __fps2:Int=0;
	private var __tfFPS:TextField;
	private var __tfMS:TextField;
	private var __tfMEM:TextField;
	private var __tfMEMMAX:TextField;
	
	public function new(stage:Stage)
	{
		super();

		__stage = stage;

		initialize();
		this.mouseChildren = this.mouseEnabled = false;
		this.addEventListener(Event.ENTER_FRAME, onRenderTick);
	}
	private function onRenderTick(e:Event):Void
	{
		var currentTime:Int = Lib.getTimer();

		if((currentTime - __prevTime) > 1000)
		{
			var fpsGraph:Int = Std.int(Math.min(GRAPH_SIZE.height, (__fps / __stage.frameRate) * GRAPH_SIZE.height));
			__fpsArr.unshift(fpsGraph);
			if (__fpsArr.length > GRAPH_SIZE.width/2)
				__fpsArr.pop();
			
			__graph.bitmapData.lock();
			__graph.bitmapData.fillRect(__rectClear, 0x00000000);
			var i:Int = 0;
			while(i<__fpsArr.length)
			{
				__rectDraw.x = i*2;
				__rectDraw.y = GRAPH_SIZE.height - __fpsArr[i];
				__rectDraw.height = __fpsArr[i];
				__graph.bitmapData.fillRect(__rectDraw, 0xccffffff);
				i++;
			}
			__graph.bitmapData.unlock();

			__prevTime = currentTime;
			
			var p:Float = Math.pow(10, 2);
			__mem = Math.round(System.totalMemory * 0.000000954 * p) / p;
			__memMax = __mem > __memMax ? __mem : __memMax;

			/*__xml.fps = "FPS: " + __fps + " / " + __stage.frameRate + " / " + __averageFps;
			__xml.mem = "MEM: " + __mem;
			__xml.memMax = "MAX: " + __memMax;
			__xml.memP = "PROC: " + (System.privateMemory * 0.000000954).toFixed(2);
			__xml.memF = "GARB: " + (System.freeMemory * 0.000000954).toFixed(2);*/
			
			__tfFPS.text = "FPS:" + __fps + "/" + __stage.frameRate + "/" + __averageFps;
			__tfMEM.text = "MEM:" + __mem;
			__tfMEMMAX.text = "MAX:" + __memMax;

			//for averageFps
			__timeCount++;
			__averageFps = Std.int(__framesCount / __timeCount);
			if(__timeCount > 108000)
			{
				__timeCount = 0;
				__framesCount = 0;
			}

			__fps = 0;
		}

		__fps++;

		//for averageFps
		__framesCount++;

		//__xml.ms = "MS: " + (currentTime - __ms);
		__tfMS.text = "MS:" + (currentTime - __ms);
		__ms = currentTime;
		
		//#if !js
		var p:Float = __memMax == 0?1:(__mem / __memMax);
		__memBm.width += p * GRAPH_SIZE.width * .3 - __memBm.width * .3;
		//#end
	}
	private function initialize():Void
	{
		var bg:Bitmap = new Bitmap(new BitmapData(Std.int(SIZE.width), Std.int(SIZE.height), true, -1306385886));
		this.addChild(bg);
 
		var colorBm:Bitmap = new Bitmap(new BitmapData(Std.int(GRAPH_SIZE.width), Std.int(GRAPH_SIZE.height + 5), false, 0x01b0f0));
		colorBm.x = colorBm.y = MARGIN;
		colorBm.bitmapData.fillRect(new Rectangle(0, 0, GRAPH_SIZE.width, GRAPH_SIZE.height * .6), 0x4cc7f3);
		this.addChild(colorBm);

		__memBm = new Bitmap(new BitmapData(Std.int(GRAPH_SIZE.width), Std.int(GRAPH_SIZE.height * .4), false, 0xaeee00));
		__memBm.x = MARGIN;
		__memBm.y = GRAPH_SIZE.height + MARGIN + 10;
		this.addChild(__memBm);

		__graph = new Bitmap();
		__graph.bitmapData = new BitmapData(Std.int(GRAPH_SIZE.width), Std.int(GRAPH_SIZE.height), true, 0x0);
		__graph.x = MARGIN;
		__graph.y = MARGIN + 5;
		this.addChild(__graph);
		
		__rectClear = __graph.bitmapData.rect;
		__rectDraw = __rectClear;
		__rectDraw.width = 2;

		//__xml = '<xml><fps>FPS:</fps><ms>MS:</ms><mem>MEM:</mem><memMax>MAX:</memMax><memP>PROC:</memP><memF>GARB:</memF></xml>';

		/*var css:StyleSheet = new StyleSheet();
		css.setStyle("xml", {fontSize:'9px', fontFamily:'Tahoma', fontWeight:'bold', leading:'-2px'});
		css.setStyle("fps", {color:hex2css(COLORS.fps)});
		css.setStyle("ms", {color:hex2css(COLORS.ms)});
		css.setStyle("mem", {color:hex2css(COLORS.mem)});
		css.setStyle("memMax", {color:hex2css(COLORS.memmax)});
		css.setStyle("memP", {color:hex2css(COLORS.ms)});
		css.setStyle("memF", {color:hex2css(COLORS.ms)});*/

		//__tf.height = SIZE.height;
		//__tf.styleSheet = css;
		
		__tfFPS = getTextField(COLORS.fps, "FPS:");
		__tfFPS.x = MARGIN;
		__tfFPS.y = __memBm.y + MARGIN;
		this.addChild(__tfFPS);
		__tfMS = getTextField(COLORS.ms, "MS:");
		__tfMS.x = MARGIN;
		__tfMS.y = __tfFPS.y + __tfFPS.height;
		this.addChild(__tfMS);
		__tfMEM = getTextField(COLORS.mem, "MEM:");
		__tfMEM.x = MARGIN;
		__tfMEM.y = __tfMS.y + __tfMS.height;
		this.addChild(__tfMEM);
		__tfMEMMAX = getTextField(COLORS.memmax, "MAX:");
		__tfMEMMAX.x = MARGIN;
		__tfMEMMAX.y = __tfMEM.y + __tfMEM.height;
		this.addChild(__tfMEMMAX);
	}
	private function getTextField(color:Int, text:String):TextField
	{
		var font:String = "Tahoma";
		#if mobile
		font = null;
		#end
		var tf:TextField = new TextField();
		tf.defaultTextFormat = new TextFormat(font, 9, color, true);
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.selectable = false;
		tf.mouseEnabled = false;
		tf.multiline = false;
		tf.wordWrap = false;
		tf.text = text;
		tf.height = tf.textHeight;
		
		//tf.border = true;
		//tf.borderColor = 0xff0000;
		
		#if flash
		tf.condenseWhite = true;
		tf.mouseWheelEnabled = false;
		#end
		
		return tf;
	}
}

private class Logger extends Sprite
{
	private var __messageLogger:TextField;
	private var __timeLogger:TextField;

	public function new()
	{
		super();

		this.mouseChildren = this.mouseEnabled = false;

		var bg:Bitmap = new Bitmap(new BitmapData(500, 240, true, -1306385886));
		this.addChild(bg);

		var font:String = "Tahoma";
		#if mobile
		font = null;
		#end
		
		__messageLogger = new TextField();
		__messageLogger.defaultTextFormat = new TextFormat(font, 9, 0xFFFFFF, true);
		__messageLogger.wordWrap = true;
		__messageLogger.width = 433;
		__messageLogger.height = 230;
		__messageLogger.x = 7;
		__messageLogger.y = 5;
		this.addChild(__messageLogger);

		__timeLogger = new TextField();
		__timeLogger.defaultTextFormat = new TextFormat(font, 9, 0xAAAAAA, true);
		__timeLogger.wordWrap = false;
		__timeLogger.width = 500 - 14 - __messageLogger.width;
		__timeLogger.height = __messageLogger.height;
		__timeLogger.x = __messageLogger.x + __messageLogger.width;
		__timeLogger.y = 5;
		this.addChild(__timeLogger);

		__messageLogger.selectable = __messageLogger.mouseEnabled = false;
		__timeLogger.selectable = __timeLogger.mouseEnabled = false;
		#if flash
		__messageLogger.mouseWheelEnabled = false;
		__timeLogger.mouseWheelEnabled = false;
		#end
	}
	public function log(param1:Dynamic, param2:Dynamic = null, param3:Dynamic = null, param4:Dynamic = null, param5:Dynamic = null):Void
	{
		//__messageLogger.appendText(param.toString() + "\n");
		if (param5 != null)
		{
			__messageLogger.appendText(param1 + ",");
			__messageLogger.appendText(param2 + ",");
			__messageLogger.appendText(param3 + ",");
			__messageLogger.appendText(param4 + ",");
			__messageLogger.appendText(param5 + "\n");
		}
		else if (param4 != null)
		{
			__messageLogger.appendText(param1 + ",");
			__messageLogger.appendText(param2 + ",");
			__messageLogger.appendText(param3 + ",");
			__messageLogger.appendText(param4 + "\n");
		}
		else if (param3 != null)
		{
			__messageLogger.appendText(param1 + ",");
			__messageLogger.appendText(param2 + ",");
			__messageLogger.appendText(param3 + "\n");
		}
		else if (param2 != null)
		{
			__messageLogger.appendText(param1 + ",");
			__messageLogger.appendText(param2 + "\n");
		}
		else
			__messageLogger.appendText(param1+ "\n");
		
		__timeLogger.appendText(Std.string(Lib.getTimer()) + "\n");
		
		if(__messageLogger.numLines > 18)
		{
			var searchEnter:String = "\n";
			#if flash
			searchEnter = "\r";
			#end
			
			var index:Int = __messageLogger.text.indexOf(searchEnter, 0);
			__messageLogger.text = __messageLogger.text.substring(index + 1, __messageLogger.text.length);
			
			index = __timeLogger.text.indexOf(searchEnter, 0);
			__timeLogger.text = __timeLogger.text.substring(index + 1, __timeLogger.text.length);
		}

		if(__messageLogger.numLines > __timeLogger.numLines)
		{
			var i:Int = __messageLogger.numLines - __timeLogger.numLines;
			while((i--)>0)
			{
				__timeLogger.appendText("\n");
			}
		}
	}
}

private class TinyButton extends Sprite
{
	public function new(str:String)
	{
		super();
		
		this.mouseChildren = false;

		var s:Bitmap = new Bitmap(new BitmapData(30, 31, true, -1306385886));

		var offset:Float = 8;

		if(str == "-")
		{
			s.bitmapData.fillRect(new Rectangle(2 + offset, 6 + offset, 10, 2), 0xffffffff);
		}
		else if(str == "+")
		{
			s.bitmapData.fillRect(new Rectangle(2 + offset, 6 + offset, 10, 2), 0xffffffff);
			s.bitmapData.fillRect(new Rectangle(6 + offset, 2 + offset, 2, 10), 0xffffffff);
		}

		this.addChild(s);
	}
}