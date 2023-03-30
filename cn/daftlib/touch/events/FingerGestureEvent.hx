package cn.daftlib.touch.events;

import openfl.events.Event;

/**
 * ...
 * @author eric.lin
 */
@:final class FingerGestureEvent extends Event
{
	public static var GESTURE_PAN:String = "gesturePan";
	public static var GESTURE_ROTATE_SCALE:String = "gestureRotateScale";

	// For pan
	public var offsetX:Float;
	public var offsetY:Float;
	public var speedX:Float;
	public var speedY:Float;

	// For scale rotate
	public var scaleRatio:Float;
	public var rotationDelta:Float;
	public var registeX:Float;
	public var registeY:Float;

	public var stageX:Float;
	public var stageY:Float;

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);
	}
}