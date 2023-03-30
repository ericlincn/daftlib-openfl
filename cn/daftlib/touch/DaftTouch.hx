package cn.daftlib.touch;
import cn.daftlib.errors.DuplicateDefinedError;
import cn.daftlib.touch.clients.MouseClient;
import cn.daftlib.touch.clients.TouchDeviceType;
import cn.daftlib.touch.clients.TouchScreenClient;
import openfl.display.Stage;
import openfl.ui.Multitouch;
import openfl.ui.MultitouchInputMode;

/**
 * ...
 * @author eric.lin
 */
@:final class DaftTouch
{
	private static var __initialized:Bool = false;
	
	public function new(stage:Stage, touchDeviceType:String = TouchDeviceType.TOUCH_SCREEN)
	{
		if(__initialized == true)
			throw new DuplicateDefinedError("[class DaftTouch]");

		if(touchDeviceType == TouchDeviceType.MOUSE)
		{
			new MouseClient(new TouchListener(stage), stage);
			__initialized = true;
		}
		else if(touchDeviceType == TouchDeviceType.TOUCH_SCREEN)
		{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			new TouchScreenClient(new TouchListener(stage), stage);
			__initialized = true;
		}
	}
}