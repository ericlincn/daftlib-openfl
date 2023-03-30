package cn.daftlib.utils;
import cn.adobe.utils.BezierSegment;
import openfl.display.Graphics;
import openfl.geom.Point;

/**
 * ...
 * @author eric.lin
 */
@:final class GraphicsCurveUtil
{
	private static inline var PI:Float = 3.141592653589793;
	private static inline var PI_M2:Float = PI * 2;
	private static inline var PI_D2:Float = PI / 2;
	
	public static function curveUsingAnchor(g:Graphics, pointsArr:Array<Point>, close:Bool=false):Void
	{
		var x1:Float=pointsArr[0].x;
		var y1:Float=pointsArr[0].y;
		
		var firstPtIndex:Int = 1;
		var lastPtIndex:Int = pointsArr.length - 2;
		//var i:Int;
		if(close && pointsArr.length > 2)
		{
			firstPtIndex = 0;
			lastPtIndex = pointsArr.length-1;
			x1 = (pointsArr[0].x + pointsArr[lastPtIndex].x) / 2;
			y1 = (pointsArr[0].y + pointsArr[lastPtIndex].y) / 2;
		}
		var i:Int = lastPtIndex - 1;
		
		g.moveTo(x1, y1);
		for(i in firstPtIndex...lastPtIndex)
		{
			var xc:Float = (pointsArr[i].x + pointsArr[i + 1].x) / 2;
			var yc:Float = (pointsArr[i].y + pointsArr[i + 1].y) / 2;
			g.curveTo(pointsArr[i].x, pointsArr[i].y, xc, yc);
		}
		
		if(pointsArr.length <= 1)
		{
			//do nothing
		}
		else if(pointsArr.length == 2)
		{
			//drawLine();
			g.moveTo(pointsArr[0].x, pointsArr[0].y);
			g.lineTo(pointsArr[1].x, pointsArr[1].y);
		}
		else
		{
			if(close)
				g.curveTo(pointsArr[i].x, pointsArr[i].y, x1, y1);
			else
				g.curveTo(pointsArr[i].x, pointsArr[i].y, pointsArr[i+1].x,
					pointsArr[i+1].y); 
		}
	}
	public static function curveThroughPoints(g:Graphics, pointsArr:Array<Point>, d:Float = .2, close:Bool = false):Void
	{
		//Two Control Points for each control point
		var controlPointsA:Array<Point> = [];
		var controlPointsB:Array<Point> = [];

		//calculating first and last point for iteration
		var firstPtIndex:Int = 1;
		var lastPtIndex:Int = pointsArr.length - 1;
		var i:Int;
		if(close && pointsArr.length > 2)
		{
			//If this is a closed curve
			firstPtIndex = 0;
			lastPtIndex = pointsArr.length;
		}
		//Looping thru all curve points to calculate control points
		//We loop from  2nd point to 2nd to last point
		//first point and last point are edge cases we come to later
		for(i in firstPtIndex...lastPtIndex)
		{
			//The prev, current and next point in our iteration
			var p0:Point = ((i - 1 < 0) ? pointsArr[pointsArr.length - 2] : pointsArr[i - 1]);
			var p1:Point = pointsArr[i];
			var p2:Point = ((i + 1 == pointsArr.length) ? pointsArr[1] : pointsArr[i + 1]);

			//Calculating the distance of points and using a min length
			var a:Float = Point.distance(p0, p1);
			a = Math.max(a, 0.01);
			var b:Float = Point.distance(p1, p2);
			b = Math.max(b, 0.01);
			var c:Float = Point.distance(p2, p0);
			c = Math.max(c, 0.01);
			//Angle between the 2 sides of the triangle
			var C:Float = Math.acos((b * b + a * a - c * c) / (2 * b * a));

			//Relative set of points
			var aPt:Point = new Point(p0.x - p1.x, p0.y - p1.y);
			var bPt:Point = new Point(p1.x, p1.y);
			var cPt:Point = new Point(p2.x - p1.x, p2.y - p1.y);

			if(a > b)
			{
				aPt.normalize(b);
			}
			else if(b > a)
			{
				cPt.normalize(a);
			}

			//Since the points are normalized
			//we put them back to their original position
			aPt.offset(p1.x, p1.y);
			cPt.offset(p1.x, p1.y);

			//Calculating vectors ba and bc
			var ax:Float = bPt.x - aPt.x;
			var ay:Float = bPt.y - aPt.y;
			var bx:Float = bPt.x - cPt.x;
			var by:Float = bPt.y - cPt.y;
			//Adding the two vectors gives the line perpendicular to the
			//control point line
			var rx:Float = ax + bx;
			var ry:Float = ay + by;
			var r:Float = Math.sqrt(rx * rx + ry * ry); //not reqd
			var theta:Float = Math.atan(ry / rx);


			//var controlDist:Number = Math.min(a, b)*_cpSlider.value;
			var controlDist:Float = Math.min(a, b) * d;

			var controlScaleFactor:Float = C / PI;
			//controlDist *= ((1-angleFactor)) + (angleFactor*controlScaleFactor));
			var controlAngle:Float = theta + PI_D2;

			var cp1:Point = Point.polar(controlDist, controlAngle + PI);
			var cp2:Point = Point.polar(controlDist, controlAngle);
			//offset these control points to put them in the right place
			cp1.offset(p1.x, p1.y);
			cp2.offset(p1.x, p1.y);

			//ensureing P1 and P2 are not switched
			if(Point.distance(cp2, p2) > Point.distance(cp1, p2))
			{
				//swap cp1 and cp2
				var dummyX:Float = cp1.x;
				cp1.x = cp2.x;
				cp2.x = dummyX;
				var dummyY:Float = cp1.y;
				cp1.y = cp2.y;
				cp2.y = dummyY;
			}

			controlPointsA[i] = cp1;
			controlPointsB[i] = cp2;
		}


		if(pointsArr.length <= 1)
		{
			//do nothing
		}
		else if(pointsArr.length == 2)
		{
			//drawLine();
			g.moveTo(pointsArr[0].x, pointsArr[0].y);
			g.lineTo(pointsArr[1].x, pointsArr[1].y);
		}
		else
		{
			//drawCurve();
			//Calculating First and Last Points
			if(close)
			{
				//If this is a closed curve
				firstPtIndex = 0;
				lastPtIndex = pointsArr.length + 1;
			}

			//Drawing the Curve
			//_graphics.lineStyle(0,0x000000, 1.0);
			g.moveTo(pointsArr[0].x, pointsArr[0].y);

			//If this isnt a closed line
			if(firstPtIndex == 1)
			{
				//If this is a closed curve
				//Drawing a regular quadratic bezier curve from first to second point
				//using control point of the second point
				g.curveTo(controlPointsA[1].x, controlPointsA[1].y, pointsArr[1].x, pointsArr[1].y);
			}

			//Looping thru various points for drawing cubic bezzier curves
			for(i in firstPtIndex...(lastPtIndex - 1))
			{
				//var prevIndex:int = ((i-1 < 0) ? _points.length-2 : i-1);
				var nextIndex:Int = ((i + 1 == pointsArr.length) ? 0 : i + 1);
				drawBezzFromFourPoints(g, pointsArr[i], controlPointsB[i], controlPointsA[nextIndex], pointsArr[nextIndex]);
			}
			//If this isnt a closed curve 
			if(lastPtIndex == pointsArr.length - 1)
			{
				//make the last curve and make it quadratic
				g.curveTo(controlPointsB[pointsArr.length - 2].x, controlPointsB[pointsArr.length - 2].y, pointsArr[pointsArr.length - 1].x, pointsArr[pointsArr.length - 1].y);
			}
		}
	}
	private static function drawBezzFromFourPoints(g:Graphics, p1:Point, p2:Point, p3:Point, p4:Point):Void
	{
		//Util-ish function
		//This function can be optimized to use less than/more than 
		//100 points every time, based on the curvature of the curve
		var bs:BezierSegment = new BezierSegment(p1, p2, p3, p4);
		/*for(var t:Number = 0.01; t < 1.01; t += 0.01)
		{
			var val:Point = bs.getValue(t);
			g.lineTo(val.x, val.y);
		}*/
		for(t in 1...101)
		{
			var val:Point = bs.getValue(t/100);
			g.lineTo(val.x, val.y);
		}
	}
	public static function lineThroughPoints(g:Graphics, pointsArr:Array<Point>, close:Bool = false):Void
	{
		g.moveTo(pointsArr[0].x, pointsArr[0].y);
		for(i in 0...pointsArr.length)
		{
			g.lineTo(pointsArr[i].x, pointsArr[i].y);
		}
		if(close==true)
			g.lineTo(pointsArr[0].x, pointsArr[0].y);
	}
}