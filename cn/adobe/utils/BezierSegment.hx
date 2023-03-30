package cn.adobe.utils;
import openfl.geom.Point;

/**
 * ...
 * @author eric.lin
 */
private typedef Number = Float;

class BezierSegment
{
	public var a:Point;
	public var b:Point;
	public var c:Point;
	public var d:Point;
	
	public function new(a:Point, b:Point, c:Point, d:Point) 
	{
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
	}
	
	public function getValue(t:Number):Point
	{
		var ax:Number = this.a.x;
		var x:Number = (t * t * (this.d.x - ax) + 3 * (1 - t) * (t * (this.c.x - ax) + (1 - t) * (this.b.x - ax))) * t + ax;
		var ay:Number = this.a.y;
		var y:Number = (t * t * (this.d.y - ay) + 3 * (1 - t) * (t * (this.c.y - ay) + (1 - t) * (this.b.y - ay))) * t + ay;
		return new Point(x, y);
	}
	
	public static function getSingleValue(t:Number, a:Number = 0, b:Number = 0, c:Number = 0, d:Number = 0):Number
	{
		return (t * t * (d - a) + 3 * (1 - t) * (t * (c - a) + (1 - t) * (b - a))) * t + a;
	}
	
	public function getYForX(x:Number, coefficients:Array<Float> = null):Null<Number>
	{
		// Clamp to range between end points.
		// The padding with the small decimal value is necessary to avoid bugs
		// that result from reaching the limits of decimal precision in calculations.
		// We have tests that demonstrate this.
		if(this.a.x < this.d.x)
		{
			if(x <= this.a.x + 0.0000000000000001)
				return this.a.y;
			if(x >= this.d.x - 0.0000000000000001)
				return this.d.y;
		}
		else
		{
			if(x >= this.a.x + 0.0000000000000001)
				return this.a.y;
			if(x <= this.d.x - 0.0000000000000001)
				return this.d.y;
		}

		if(coefficients == null)
		{
			coefficients = getCubicCoefficients(this.a.x, this.b.x, this.c.x, this.d.x);
		}

		// x(t) = a*t^3 + b*t^2 + c*t + d
		var roots:Array<Float> = getCubicRoots(coefficients[0], coefficients[1], coefficients[2], coefficients[3] - x);
		var time:Null<Number> = null;
		if(roots.length == 0)
			time = 0;
		else if(roots.length == 1)
			time = roots[0];
		else
		{
			for(root in roots)
			{
				if(0 <= root && root <= 1)
				{
					time = root;
					break;
				}
			}
		}

		if(time == null)
			return null;

		var y:Number = getSingleValue(time, this.a.y, this.b.y, this.c.y, this.d.y);
		return y;
	}

	public static function getCubicCoefficients(a:Number, b:Number, c:Number, d:Number):Array<Float>
	{
		return [-a + 3 * b - 3 * c + d,
			3 * a - 6 * b + 3 * c,
			-3 * a + 3 * b,
			a];
	}

	public static function getCubicRoots(a:Number = 0, b:Number = 0, c:Number = 0, d:Number = 0):Array<Float>
	{
		// make sure we really have a cubic
		if(a == 0)
			return BezierSegment.getQuadraticRoots(b, c, d);

		// normalize the coefficients so the cubed term is 1 and we can ignore it hereafter
		if(a != 1)
		{
			b /= a;
			c /= a;
			d /= a;
		}

		var q:Number = (b * b - 3 * c) / 9; // won't change over course of curve
		var qCubed:Number = q * q * q; // won't change over course of curve
		var r:Number = (2 * b * b * b - 9 * b * c + 27 * d) / 54; // will change because d changes
		// but parts with b and c won't change
		// determine if there are 1 or 3 real roots using r and q
		var diff:Number = qCubed - r * r; // will change
		if(diff >= 0)
		{
			// avoid division by zero
			if(q == 0)
				return [0];
			// three real roots
			var theta:Number = Math.acos(r / Math.sqrt(qCubed)); // will change because r changes
			var qSqrt:Number = Math.sqrt(q); // won't change

			var root1:Number = -2 * qSqrt * Math.cos(theta / 3) - b / 3;
			var root2:Number = -2 * qSqrt * Math.cos((theta + 2 * Math.PI) / 3) - b / 3;
			var root3:Number = -2 * qSqrt * Math.cos((theta + 4 * Math.PI) / 3) - b / 3;

			return [root1, root2, root3];
		}
		else
		{
			// one real root
			var tmp:Number = Math.pow(Math.sqrt(-diff) + Math.abs(r), 1 / 3);
			var rSign:Int = (r > 0) ? 1 : r < 0 ? -1 : 0;
			var root:Number = -rSign * (tmp + q / tmp) - b / 3;
			return [root];
		}
		return [];
	}

	public static function getQuadraticRoots(a:Number, b:Number, c:Number):Array<Float>
	{
		var roots:Array<Float> = [];
		// make sure we have a quadratic
		if(a == 0)
		{
			if(b == 0)
				return [];
			roots[0] = -c / b;
			return roots;
		}

		var q:Number = b * b - 4 * a * c;
		var signQ:Int = (q > 0) ? 1 : q < 0 ? -1 : 0;

		if(signQ < 0)
		{
			return [];
		}
		else if(signQ == 0)
		{
			roots[0] = -b / (2 * a);
		}
		else
		{
			roots[0] = roots[1] = -b / (2 * a);
			var tmp:Number = Math.sqrt(q) / (2 * a);
			roots[0] -= tmp;
			roots[1] += tmp;
		}

		return roots;
	}
}