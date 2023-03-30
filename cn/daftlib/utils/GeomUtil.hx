package cn.daftlib.utils;
import openfl.geom.Point;

/**
 * ...
 * @author eric.lin
 */
@:final class GeomUtil
{
	public static inline var PI:Float = 3.141592653589793;
	public static inline var PI_M2:Float = PI * 2;
	public static inline var PI_D2:Float = PI / 2;
	
	private static inline var toRADIANS:Float = PI / 180;
	private static inline var toDEGREES:Float = 180 / PI;
	
	private static inline var B = 4 / PI;
	private static inline var C = -4 / (PI*PI);
	private static inline var P = 0.225;
	
	// fast, but wrong result while abs(x)>PI
	inline public static function sin(x:Float):Float
	{
		var y = B * x + C * x * NumberUtil.abs(x);
		
		return P * (y * NumberUtil.abs(y) - y) + y;
	}
	// fast, but wrong result while abs(x)>PI
	inline public static function cos(x:Float):Float
	{
		x = x + PI_D2;
		if (x > PI)
			x -= PI_M2;
		var y = B * x + C * x * NumberUtil.abs(x);
		
		return P * (y * NumberUtil.abs(y) - y) + y;
	}
	
	/**
	 * Calculates a scale value to maintain aspect ratio and fill the required
	 * bounds (with the possibility of cutting of the edges a bit).
	 */
	public static function getScaleRatioToFill(originalWidth:Float, originalHeight:Float, targetWidth:Float, targetHeight:Float):Float
	{
		var widthRatio:Float = targetWidth / originalWidth;
		var heightRatio:Float = targetHeight / originalHeight;
		return Math.max(widthRatio, heightRatio);
	}
	/**
	 * Calculates a scale value to maintain aspect ratio and fit inside the
	 * required bounds (with the possibility of a bit of empty space on the edges).
	 */
	public static function getScaleRatioToFit(originalWidth:Float, originalHeight:Float, targetWidth:Float, targetHeight:Float):Float
	{
		var widthRatio:Float = targetWidth / originalWidth;
		var heightRatio:Float = targetHeight / originalHeight;
		return Math.min(widthRatio, heightRatio);
	}
	/**
	 * Converts degrees to radians.
	 * @param $degrees
	 * @return
	 */
	inline public static function degreesToRadians(degrees:Float):Float
	{
		return degrees * toRADIANS;
	}

	/**
	 * Converts radians to degrees.
	 * @param $radians
	 * @return
	 */
	inline public static function radiansToDegrees(radians:Float):Float
	{
		return radians * toDEGREES;
	}

	/**
	 * 得到(椭)圆上点的坐标
	 * @param $center
	 * @param $angleInDegrees
	 * @param $radius
	 * @return
	 */
	inline public static function getPositionOnCircle(centerX:Float, centerY:Float, angleInDegrees:Float, radiusX:Float, radiusY:Float):Point
	{
		var radians:Float = degreesToRadians(angleInDegrees);

		return new Point(centerX + Math.cos(radians) * radiusX, centerY + Math.sin(radians) * radiusY);
	}
	
	/**
	 * 求圆心(0, 0)正圆点上的坐标；将角速度分解；将角加速分解
	 * @param angleInDegrees
	 * @param length
	 * @return 
	 */	
	inline public static function getResolutionByVector(angleInDegrees:Float, length:Float):Point
	{
		return getPositionOnCircle(0, 0, angleInDegrees, length, length);
	}

	/**
	 * 取得两点中点
	 * @param $point1
	 * @param $point2
	 * @return
	 */
	inline public static function getMiddlePoint(point1:Point, point2:Point):Point
	{
		return Point.interpolate(point1, point2, .5);
	}

	/**
	 * 取得线的角度
	 * @param $point1
	 * @param $point2
	 * @return
	 */
	public static function getAngle(point1:Point, point2:Point):Float
	{
		var offsetX:Float = point2.x - point1.x;
		var offsetY:Float = point1.y - point2.y;
		var angle:Float = radiansToDegrees(Math.atan2(offsetY, offsetX));

		return angle;
	}

	/**
	 * Take a degree measure and make sure it is between 0..360.
	 * @param $degrees
	 * @return
	 */
	public static function unwrapDegrees(degrees:Float):Float
	{
		while(degrees > 360)
			degrees -= 360;
		while(degrees < 0)
			degrees += 360;

		return degrees;
	}

	/**
	 * Return the shortest distance to get from from to to, in degrees.
	 * @param $from
	 * @param $to
	 * @return
	 */
	public static function getDegreesShortDelta(from:Float, to:Float):Float
	{
		// Unwrap both from and to.
		from = unwrapDegrees(from);
		to = unwrapDegrees(to);

		// Calc delta.
		var delta:Float = to - from;

		// Make sure delta is shortest path around circle.
		if(delta > 180)
			delta -= 360;
		if(delta < -180)
			delta += 360;

		return delta;
	}

	/**
	 * 判断两线段是否相交
	 * @param $point1
	 * @param $point2
	 * @param $point3
	 * @param $point4
	 * @return
	 */
	public static function getIntersect(point1:Point, point2:Point, point3:Point, point4:Point):Point
	{
		var v1:Point = new Point();
		var v2:Point = new Point();
		var d:Float;
		var intersectPoint:Point = new Point();

		v1.x = point2.x - point1.x;
		v1.y = point2.y - point1.y;
		v2.x = point4.x - point3.x;
		v2.y = point4.y - point3.y;

		d = v1.x * v2.y - v1.y * v2.x;
		if(d == 0)
		{
			//points are collinear
			return null;
		}

		var a:Float = point3.x - point1.x;
		var b:Float = point3.y - point1.y;
		var t:Float = (a * v2.y - b * v2.x) / d;
		var s:Float = (b * v1.x - a * v1.y) / -d;
		if(t < 0 || t > 1 || s < 0 || s > 1)
		{
			//line segments don't intersect
			return null;
		}

		intersectPoint.x = point1.x + v1.x * t;
		intersectPoint.y = point1.y + v1.y * t;
		return intersectPoint;
	}
	
	/**
	 * 获取两正圆公切线,返回值可能为null或2条外切线或2条外切线+2条内切线
	 * @param x1
	 * @param y1
	 * @param radius1
	 * @param x2
	 * @param y2
	 * @param radius2
	 * @return 
	 */	
	public static function getTangents(x1:Float, y1:Float, radius1:Float, x2:Float, y2:Float, radius2:Float):Array<Array<Point>>
	{
		var dsq:Float = (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
		if (dsq <= (radius1 - radius2) * (radius1 - radius2)) return null;
		
		var d:Float = Math.sqrt(dsq);
		var vx:Float = (x2 - x1) / d;
		var vy:Float = (y2 - y1) / d;
		
		var result:Array<Array<Point>> = [];
		var i:Int = 0;
		
		// Let A, B be the centers, and C, D be points at which the tangent
		// touches first and second circle, and n be the normal vector to it.
		//
		// We have the system:
		//   n * n = 1          (n is a unit vector)          
		//   C = A + r1 * n
		//   D = B +/- r2 * n
		//   n * CD = 0         (common orthogonality)
		//
		// n * CD = n * (AB +/- r2*n - r1*n) = AB*n - (r1 -/+ r2) = 0,  <=>
		// AB * n = (r1 -/+ r2), <=>
		// v * n = (r1 -/+ r2) / d,  where v = AB/|AB| = AB/d
		// This is a linear equation in unknown vector n.
		
		//for (var sign1:int = +1; sign1 >= -1; sign1 -= 2)
		var sign1:Int = 1;
		while(sign1 >= -1)
		{
			var c:Float = (radius1 - sign1 * radius2) / d;
			
			// Now we're just intersecting a line with a circle: v*n=c, n*n=1
			
			if (c * c > 1.0)
			{
				sign1 -= 2;
				continue;
			}
			
			var h:Float = Math.sqrt(Math.max(0.0, 1.0 - c*c));
			
			var sign2:Int = 1;
			//for (var sign2:int = +1; sign2 >= -1; sign2 -= 2)
			while(sign2 >= -1)
			{
				var nx:Float = vx * c - sign2 * h * vy;
				var ny:Float = vy * c + sign2 * h * vx;
				
				var a:Array<Point> = result[i++] = [];
				a[0] = new Point(x1 + radius1 * nx, y1 + radius1 * ny);
				a[1] = new Point(x2 + sign1 * radius2 * nx, y2 + sign1 * radius2 * ny);
				
				sign2 -= 2;
			}
			
			sign1 -= 2;
		}
		
		return result;
	}
}