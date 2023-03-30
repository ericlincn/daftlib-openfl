package cn.daftlib.utils;
import openfl.display.GradientType;
import openfl.display.Graphics;
import openfl.display.SpreadMethod;
import openfl.geom.Matrix;
import openfl.geom.Point;

/**
 * ...
 * @author eric.lin
 */
@:final class GraphicsUtil
{
	public static function simpleLinearGradient(g:Graphics, color:Int, color2:Int, angle:Float, width:Float, height:Float):Void
	{
		var fillType:GradientType = GradientType.LINEAR;
		var colors:Array<Int> = [color, color2];
		var alphas:Array<Float> = [1, 1];
		var ratios:Array<Int> = [0x00, 0xFF];
		var matr:Matrix = new Matrix();
		matr.createGradientBox(width, height, angle * Math.PI / 180, 0, 0);
		var spreadMethod:SpreadMethod = SpreadMethod.PAD;
		g.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
	}

	public static function drawDashed(g:Graphics, pt1:Point, pt2:Point, len:Float = 5, gap:Float = 5):Void
	{
		var dist:Float = Point.distance(pt1, pt2);
		var pt3:Point;
		var pt4:Point;

		var i:Float = 0;
		while(i < dist)
		{
			pt3 = Point.interpolate(pt1, pt2, i / dist);
			i += len;

			if(i > dist)
				i = dist;

			pt4 = Point.interpolate(pt1, pt2, i / dist);

			g.moveTo(pt3.x, pt3.y);
			g.lineTo(pt4.x, pt4.y);

			i += gap;
		}
	}

	public static function drawCircularSector(g:Graphics, center:Point, radius:Float, angle:Float, startAngle:Float):Void
	{
		var a:Float = (Math.abs(angle) > 360) ? 360 : angle;
		var n:Float = Math.ceil(Math.abs(a) / 45);
		var angleDelta:Float = a / n;
		angleDelta = GeomUtil.degreesToRadians(angleDelta);
		var sa:Float = GeomUtil.degreesToRadians(startAngle);

		g.moveTo(center.x, center.y);
		g.lineTo(center.x + radius * Math.cos(sa), center.y + radius * Math.sin(sa));

		var i:Int = 0;
		while(i < n)
		{
			sa += angleDelta;
			var angleMid:Float = sa - angleDelta / 2;
			var bx:Float = center.x + radius / Math.cos(angleDelta / 2) * Math.cos(angleMid);
			var by:Float = center.y + radius / Math.cos(angleDelta / 2) * Math.sin(angleMid);
			var cx:Float = center.x + radius * Math.cos(sa);
			var cy:Float = center.y + radius * Math.sin(sa);
			g.curveTo(bx, by, cx, cy);

			i++;
		}

		if(a != 360)
			g.lineTo(center.x, center.y);
	}

	public static function drawCircularSegment(g:Graphics, center:Point, radius:Float, angle:Float, startAngle:Float, close:Bool = false):Void
	{
		var a:Float = (Math.abs(angle) > 360) ? 360 : angle;
		var n:Float = Math.ceil(Math.abs(a) / 45);
		var angleDelta:Float = a / n;
		angleDelta = GeomUtil.degreesToRadians(angleDelta);
		var sa:Float = GeomUtil.degreesToRadians(startAngle);

		g.moveTo(center.x + radius * Math.cos(sa), center.y + radius * Math.sin(sa));

		var i:Int = 0;
		while(i < n)
		{
			sa += angleDelta;
			var angleMid:Float = sa - angleDelta / 2;
			var bx:Float = center.x + radius / Math.cos(angleDelta / 2) * Math.cos(angleMid);
			var by:Float = center.y + radius / Math.cos(angleDelta / 2) * Math.sin(angleMid);
			var cx:Float = center.x + radius * Math.cos(sa);
			var cy:Float = center.y + radius * Math.sin(sa);
			g.curveTo(bx, by, cx, cy);

			i++;
		}

		if(a != 360 && close == true)
			g.lineTo(center.x + radius * Math.cos(GeomUtil.degreesToRadians(startAngle)), center.y + radius * Math.sin(GeomUtil.degreesToRadians(startAngle)));
	}

	public static function drawScarceCircularSector(g:Graphics, center:Point, radius:Float, radius2:Float, angle:Float, startAngle:Float):Void
	{
		var a:Float = (Math.abs(angle) > 360) ? 360 : angle;
		var n:Float = Math.ceil(Math.abs(a) / 45);
		var angleDelta:Float = a / n;
		angleDelta = GeomUtil.degreesToRadians(angleDelta);
		var sa:Float = GeomUtil.degreesToRadians(startAngle);
		
		var minRadius:Float=Math.min(radius, radius2);
		var maxRadius:Float=Math.max(radius, radius2);
		radius=maxRadius;
		radius2=minRadius;

		var startX:Float = center.x + radius2 * Math.cos(sa);
		var startY:Float = center.y + radius2 * Math.sin(sa);

		g.moveTo(startX, startY);
		g.lineTo(center.x + radius * Math.cos(sa), center.y + radius * Math.sin(sa));

		var angleMid:Float;
		var bx:Float;
		var by:Float;
		var cx:Float;
		var cy:Float;

		var i:Int = 0;
		while(i < n)
		{
			sa += angleDelta;
			angleMid = sa - angleDelta / 2;
			bx = center.x + radius / Math.cos(angleDelta / 2) * Math.cos(angleMid);
			by = center.y + radius / Math.cos(angleDelta / 2) * Math.sin(angleMid);
			cx = center.x + radius * Math.cos(sa);
			cy = center.y + radius * Math.sin(sa);
			g.curveTo(bx, by, cx, cy);

			i++;
		}

		g.lineTo(center.x + radius2 * Math.cos(sa), center.y + radius2 * Math.sin(sa));

		i = 0;
		while(i < n)
		{
			sa -= angleDelta;
			angleMid = sa + angleDelta / 2;
			bx = center.x + radius2 / Math.cos(angleDelta / 2) * Math.cos(angleMid);
			by = center.y + radius2 / Math.cos(angleDelta / 2) * Math.sin(angleMid);
			cx = center.x + radius2 * Math.cos(sa);
			cy = center.y + radius2 * Math.sin(sa);
			g.curveTo(bx, by, cx, cy);

			i++;
		}

		if(a != 360)
			g.lineTo(startX, startY);
	}

	public static function drawRegularPolygon(g:Graphics, center:Point, sides:Int, sideLength:Float, startAngle:Float):Void
	{
		if(sides < 3)
			return;

		startAngle = GeomUtil.degreesToRadians(startAngle);

		// The angle formed between the segments from the polygon's center as shown in 
		// Figure 4-5. Since the total angle in the center is 360 degrees (2p radians),
		// each segment's angle is 2p divided by the number of sides.
		var angleDelta:Float = (2 * Math.PI) / sides;

		// Calculate the length of the radius that circumscribes the polygon (which is
		// also the distance from the center to any of the vertices).
		var radius:Float = (sideLength / 2) / Math.sin(angleDelta / 2);

		// The starting point of the polygon is calculated using trigonometry where 
		// radius is the hypotenuse and $rotation is the angle.
		var px:Float = (Math.cos(startAngle) * radius) + center.x;
		var py:Float = (Math.sin(startAngle) * radius) + center.y;

		// Move to the starting point without yet drawing a line.
		g.moveTo(px, py);

		// Draw each side. Calculate the vertex coordinates using the same trigonometric
		// ratios used to calculate px and py earlier.
		//for(var i:Number = 1; i <= sides; i++)
		for(i in 1...(sides-1))
		{
			px = (Math.cos((angleDelta * i) + startAngle) * radius) + center.x;
			py = (Math.sin((angleDelta * i) + startAngle) * radius) + center.y;
			g.lineTo(px, py);
		}
	}

	public static function drawStar(g:Graphics, center:Point, points:Int, radius:Float, radius2:Float, startAngle:Float):Void
	{
		if(points < 3)
			return;

		var angleDelta:Float = (Math.PI * 2) / points;
		startAngle = GeomUtil.degreesToRadians(startAngle);

		var angle:Float = startAngle;
		
		var minRadius:Float=Math.min(radius, radius2);
		var maxRadius:Float=Math.max(radius, radius2);
		radius2=maxRadius;
		radius=minRadius;

		var px:Float = center.x + Math.cos(angle + angleDelta / 2) * radius;
		var py:Float = center.y + Math.sin(angle + angleDelta / 2) * radius;

		g.moveTo(px, py);

		angle += angleDelta;

		//for(var i:Number = 0; i < points; i++)
		for(i in 0...points)
		{
			px = center.x + Math.cos(angle) * radius2;
			py = center.y + Math.sin(angle) * radius2;
			g.lineTo(px, py);
			px = center.x + Math.cos(angle + angleDelta / 2) * radius;
			py = center.y + Math.sin(angle + angleDelta / 2) * radius;
			g.lineTo(px, py);
			angle += angleDelta;
		}
	}

	public static function drawRoundShape(g:Graphics, pointsVec:Array<Point>, ellipseSize:Float, cubicCurve:Bool = true):Void
	{
		if(pointsVec.length < 3)
			return;

		var px:Float;
		var py:Float;

		var i:Int = 0;
		while(i < pointsVec.length)
		{
			var index0:Int = i;
			var index1:Int = i + 1;
			var index2:Int = i + 2;

			index1 = index1 >= pointsVec.length ? index1 - pointsVec.length : index1;
			index2 = index2 >= pointsVec.length ? index2 - pointsVec.length : index2;

			var p0:Point = pointsVec[index0];
			var p1:Point = pointsVec[index1];
			var p2:Point = pointsVec[index2];

			var distA:Float = Point.distance(p0, p1);
			var distB:Float = Point.distance(p1, p2);

			var f1:Float = ellipseSize / distA;
			var f2:Float = ellipseSize / distB;

			var pen0:Point = Point.interpolate(p0, p1, 1 - f1);
			var pen1:Point = Point.interpolate(p0, p1, f1);
			var pen2:Point = Point.interpolate(p1, p2, 1 - f2);

			var control0:Point = Point.interpolate(p0, p1, f1 * .5);
			var control1:Point = Point.interpolate(p1, p2, 1 - f2 * .5);

			if(cubicCurve == false)
				control0 = p1;

			if(i == 0)
				g.moveTo(pen0.x, pen0.y);

			g.lineTo(pen1.x, pen1.y);

			if(cubicCurve == true)
			{
				#if flash
				g.cubicCurveTo(control0.x, control0.y, control1.x, control1.y, pen2.x, pen2.y);
				#else
				g.curveTo(control0.x, control0.y, pen2.x, pen2.y);
				#end
			}
			else
				g.curveTo(control0.x, control0.y, pen2.x, pen2.y);

			i++;
		}
	}
}