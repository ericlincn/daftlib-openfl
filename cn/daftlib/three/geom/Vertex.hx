package cn.daftlib.three.geom;

	class Vertex
	{
		public var length(get, null):Float;
		
		public var x:Float;
		public var y:Float;
		public var z:Float;

		public var screenX:Float;
		public var screenY:Float;
		
		public var x3d:Float;
		public var y3d:Float;
		public var z3d:Float;
		
		public var scale:Float;
		
		public function new(x:Float, y:Float, z:Float)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function dot(v:Vertex):Float 
		{
			return (x * v.x + y * v.y + v.z * z);
		}
		
		public function cross(v:Vertex):Vertex 
		{
			
			var tmpX:Float = (v.y * z) - (v.z * y);
			var tmpY:Float = (v.z * x) - (v.x * z);
			var tmpZ:Float = (v.x * y) - (v.y * x);
			
			return new Vertex(tmpX, tmpY, tmpZ);
		}
		
		public function get_length():Float 
		{
			return Math.sqrt(x * x + y * y + z * z);
		}
	}
