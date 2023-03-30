package cn.daftlib.three.geom;

	class Object3D
	{
		public var x:Float = 0;
		public var y:Float = 0;
		public var z:Float = 0;
		
		public var rotationX(get, set):Float;
		public var rotationY(get, set):Float;
		public var rotationZ(get, set):Float;
		private var __angleX:Float = 0;
		private var __angleY:Float = 0;
		private var __angleZ:Float = 0;
		
		public var scaleX:Float = 1;
		public var scaleY:Float = 1;
		public var scaleZ:Float = 1;
		
		public function new(){}
		
		public function set_rotationX(angle:Float):Float 
		{
			return __angleX = angle;
		}
		public function get_rotationX():Float 
		{
			return __angleX;
		}
		public function set_rotationY(angle:Float):Float 
		{
			return __angleY = angle;
		}
		public function get_rotationY():Float 
		{
			return __angleY;
		}
		public function set_rotationZ(angle:Float):Float 
		{
			return __angleZ = angle;
		}
		public function get_rotationZ():Float 
		{
			return __angleZ;
		}
	}
