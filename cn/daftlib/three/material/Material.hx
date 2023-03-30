package cn.daftlib.three.material;

	import openfl.display.BitmapData;

	class Material
	{
		public var color:Int;
		public var alpha:Float;
		public var texture:BitmapData;
		public var doubleSided:Bool = false;
		public var smoothed:Bool = false;
		public var calculateLights:Bool = true;
		
		public function new(color:Int, alpha:Float, texture:BitmapData = null, doubleSided:Bool = false, smoothed:Bool = false, additive:Bool = false, calculateLights:Bool = false)
		{
			this.color = color;
			this.alpha = alpha;
			this.texture = texture;
			this.doubleSided = doubleSided;
			this.smoothed = smoothed;
			this.calculateLights = calculateLights;
		}
	}
