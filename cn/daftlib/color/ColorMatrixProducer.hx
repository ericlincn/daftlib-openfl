package cn.daftlib.color;

/**
 * NOT AVAILABLE IN HTML5 TARGET
 * @author eric.lin
 */
@:final class ColorMatrixProducer
{
	// constant for contrast calculations:
	private var DELTA_INDEX:Array<Float> = [
		0,    0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1,  0.11,
		0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24,
		0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42,
		0.44, 0.46, 0.48, 0.5,  0.53, 0.56, 0.59, 0.62, 0.65, 0.68, 
		0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98,
		1.0,  1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54,
		1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0,  2.12, 2.25, 
		2.37, 2.50, 2.62, 2.75, 2.87, 3.0,  3.2,  3.4,  3.6,  3.8,
		4.0,  4.3,  4.7,  4.9,  5.0,  5.5,  6.0,  6.5,  6.8,  7.0,
		7.3,  7.5,  7.8,  8.0,  8.4,  8.7,  9.0,  9.4,  9.6,  9.8, 
		10.0];

	// identity matrix constant:
	private var IDENTITY_MATRIX:Array<Float> = [
		1, 0, 0, 0, 0,
		0, 1, 0, 0, 0,
		0, 0, 1, 0, 0,
		0, 0, 0, 1, 0,
		0, 0, 0, 0, 1];
	private var LENGTH:Int;
	
	public var brightness(null, set):Float;
	public var contrast(null, set):Float;
	public var saturation(null, set):Float;
	public var hue(null, set):Float;
	
	public var colorMatrix(get, null):Array<Float>;
	private var __array:Array<Float> = [];
	
	public function new(matrix:Array<Float> = null)
	{
		LENGTH = IDENTITY_MATRIX.length;
		
		matrix = fixMatrix(matrix);
		copyMatrix(((matrix.length == LENGTH) ? matrix : IDENTITY_MATRIX));
	}
	public function reset():Void
	{
		//for(var i:UInt = 0; i < LENGTH; i++)
		for (i in 0...LENGTH)
		{
			__array[i] = IDENTITY_MATRIX[i];
		}
	}
	private function get_colorMatrix():Array<Float>
	{
		return __array;
	}
	/**
	 * range: [-1, 1]
	 * @param $value
	 */
	private function set_brightness(value:Float):Float
	{
		value *= 100;
		value = limitValue(value, 100);

		/*if(value == 0 || isNaN(value))
			return;*/
			
		if(value == 0)
			return 0;

		multiplyMatrix([
			1, 0, 0, 0, value,
			0, 1, 0, 0, value,
			0, 0, 1, 0, value,
			0, 0, 0, 1, 0,
			0, 0, 0, 0, 1]);
			
		return value;
	}
	/**
	 * range: [-1, 1]
	 * @param $value
	 */
	private function set_contrast(value:Float):Float
	{
		value *= 100;
		value = limitValue(value, 100);

		/*if(value == 0 || isNaN(value))
			return;*/
			
		if(value == 0)
			return 0;

		var x:Float;
		if(value < 0)
		{
			x = 127 + value / 100 * 127;
		}
		else
		{
			x = value % 1;
			if(x == 0)
			{
				x = DELTA_INDEX[Std.int(value)];
			}
			else
			{
				//x = DELTA_INDEX[(p_val<<0)]; // this is how the IDE does it.
				x = DELTA_INDEX[(Std.int(value) << 0)] * (1 - x) + DELTA_INDEX[(Std.int(value) << 0) + 1] * x; // use linear interpolation for more granularity.
			}
			x = x * 127 + 127;
		}
		multiplyMatrix([
			x/127, 0, 0, 0, 0.5*(127 - x),
			0, x/127, 0, 0, 0.5*(127 - x),
			0, 0, x/127, 0, 0.5*(127 - x),
			0, 0, 0, 1, 0,
			0, 0, 0, 0, 1]);
			
		return value;
	}
	/**
	 * range: [-1, 1]
	 * @param $value
	 */
	private function set_saturation(value:Float):Float
	{
		value *= 100;
		value = limitValue(value, 100);

		/*if(value == 0 || isNaN(value))
			return;*/
			
		if(value == 0)
			return 0;

		var x:Float = 1 + ((value > 0) ? 3 * value / 100 : value / 100);
		var lumR:Float = 0.3086;
		var lumG:Float = 0.6094;
		var lumB:Float = 0.0820;

		multiplyMatrix([
			lumR*(1 - x)+x, lumG*(1 - x), lumB*(1 - x), 0, 0,
			lumR*(1 - x), lumG*(1 - x)+x, lumB*(1 - x), 0, 0,
			lumR*(1 - x), lumG*(1 - x), lumB*(1 - x)+x, 0, 0,
			0, 0, 0, 1, 0,
			0, 0, 0, 0, 1]);
			
		return value;
	}
	/**
	 * range: [0, 360]
	 * @param $value
	 */
	private function set_hue(value:Float):Float
	{
		value -= 180;
		value = limitValue(value, 180) / 180 * Math.PI;

		/*if(value == 0 || isNaN(value))
			return;*/
			
		if(value == 0)
			return 0;

		var cosVal:Float = Math.cos(value);
		var sinVal:Float = Math.sin(value);
		var lumR:Float = 0.213;
		var lumG:Float = 0.715;
		var lumB:Float = 0.072;

		multiplyMatrix([
			lumR+cosVal*(1 - lumR)+sinVal*(-lumR), lumG+cosVal*(-lumG)+sinVal*(-lumG), lumB+cosVal*(-lumB)+sinVal*(1 - lumB), 0, 0,
			lumR+cosVal*(-lumR)+sinVal*(0.143), lumG+cosVal*(1 - lumG)+sinVal*(0.140), lumB+cosVal*(-lumB)+sinVal*(-0.283), 0, 0,
			lumR+cosVal*(-lumR)+sinVal*(-(1 - lumR)), lumG+cosVal*(-lumG)+sinVal*(lumG), lumB+cosVal*(1 - lumB)+sinVal*(lumB), 0, 0,
			0, 0, 0, 1, 0,
			0, 0, 0, 0, 1]);
			
		return value;
	}
	/*public function clone():ColorMatrixProducer
	{
		return new ColorMatrixProducer(__array);
	}*/
	public function toString():String
	{
		return "[object ColorMatrix] [" + __array.join(", ") + "]";
	}

	// multiplies one matrix against another:
	private function multiplyMatrix(matrix:Array<Float>):Void
	{
		var col:Array<Float> = [];

		//for(var i:UInt = 0; i < 5; i++)
		for (i in 0...5)
		{
			//for(var j:UInt = 0; j < 5; j++)
			for (j in 0...5)
			{
				col[j] = __array[j + i * 5];
			}
			//for(j = 0; j < 5; j++)
			for (j in 0...5)
			{
				var val:Float = 0;
				//for(var k:Float = 0; k < 5; k++)
				for (k in 0...5)
				{
					val += matrix[j + k * 5] * col[k];
				}
				__array[j + i * 5] = val;
			}
		}
	}
	// make sure values are within the specified range, hue has a limit of 180, others are 100:
	private function limitValue(value:Float, limit:Float):Float
	{
		return Math.min(limit, Math.max(-limit, value));
	}
	// copy the specified matrix's values to this matrix:
	private function copyMatrix(matrix:Array<Float>):Void
	{
		//for(var i:UInt = 0; i < LENGTH; i++)
		for (i in 0...LENGTH)
		{
			__array[i] = matrix[i];
		}
	}
	// makes sure matrixes are 5x5 (25 long):
	private function fixMatrix(matrix:Array<Float> = null):Array<Float>
	{
		if(matrix == null)
			return IDENTITY_MATRIX;

		//if(matrix is ColorMatrix)
		//if(Std.is(matrix, ColorMatrix) == true)
			matrix = matrix.slice(0);

		if(matrix.length < LENGTH)
		{
			matrix = matrix.slice(0, matrix.length).concat(IDENTITY_MATRIX.slice(matrix.length, LENGTH));
		}
		else if(matrix.length > LENGTH)
		{
			matrix = matrix.slice(0, LENGTH);
		}
		return matrix;
	}
}