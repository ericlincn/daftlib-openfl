package cn.daftlib.three.objects;

	import cn.daftlib.three.geom.Object3D;
	import cn.daftlib.utils.GeomUtil;

	class PointCamera extends Object3D
	{
		public var fov(get, set):Float;
		public var focalLength(get, null):Float;
		public var vanishingPointX(get, null):Float;
		public var vanishingPointY(get, null):Float;
		
		public var zOffset:Float = 0;
		
		private var __zoom:Float;
		private var __focalLength:Float;
		
		private var __vanishingPointX:Float;
		private var __vanishingPointY:Float;
		
		public function new(vanishingPointX:Float, vanishingPointY:Float, fov:Float=75, zoom:Float=1)
		{
			super();
			
			__vanishingPointX = vanishingPointX;
			__vanishingPointY = vanishingPointY;
			//__focalLength = focalLength;
			__zoom = zoom;
			
			this.fov=75;
		}

		public function get_focalLength():Float
		{
			return __focalLength;
		}

		public function get_vanishingPointX():Float
		{
			return __vanishingPointX;
		}

		public function get_vanishingPointY():Float
		{
			return __vanishingPointY;
		}

		private function maintainAngle(angle:Float):Float 
		{
			if(Math.abs(angle) >= GeomUtil.PI) 
			{
				if(angle < 0) 
				{
					angle += GeomUtil.PI * 2;
				}
				else 
				{
					angle -= GeomUtil.PI * 2;
				}
			}
			
			return angle;
		}
		public function follow(target:Object3D, speed:Float, turnSpeed:Float):Void
		{
			var diffZ:Float = (target.rotationX - this.rotationZ);
			var diffY:Float = (-target.rotationY - this.rotationY + GeomUtil.degreesToRadians(90));
			var diffX:Float = (target.rotationZ - this.rotationX);
			
			// avoid large gaps from -180 to 180, dirrrty test...
			diffZ = maintainAngle(diffZ);
			diffY = maintainAngle(diffY);
			diffX = maintainAngle(diffX);
			
			this.rotationZ += diffZ * turnSpeed;
			this.rotationY += diffY * turnSpeed;
			this.rotationX += diffX * turnSpeed;
			
			// limit to 0 - 360 ... the gap thing
			this.rotationZ = this.rotationZ % (GeomUtil.PI * 2);
			this.rotationY = this.rotationY % (GeomUtil.PI * 2);
			this.rotationX = this.rotationX % (GeomUtil.PI * 2);
			
			x += (target.x - x) * speed;
			y += (target.y - y) * speed;
			z += (target.z - z) * speed;
		}
		
		public function set_fov(degrees:Float):Float
		{
			var tx	:Float = 0;
			var ty	:Float = 0;
			var tz	:Float = 0;
			
			//var vx	:Float = this.x - tx;
			//var vy	:Float = this.y - ty;
			//var vz	:Float = this.z - tz;
			
			var h:Float = __vanishingPointY;
			//var d:Float = Math.sqrt(vx*vx + vy*vy + vz*vz) + this.focus;
			//var r:Float = 180 / Math.PI;
			
			var vfov:Float = (degrees/2) * (Math.PI/180);
			
			return __focalLength = (h / Math.tan(vfov)) / __zoom;
		}
		public function get_fov():Float
		{
			var tx	:Float = 0;
			var ty	:Float = 0;
			var tz	:Float = 0;
			
			var vx	:Float = this.x - tx;
			var vy	:Float = this.y - ty;
			var vz	:Float = this.z - tz;
			
			var f	:Float = __focalLength;
			var z	:Float = __zoom;
			var d	:Float = Math.sqrt(vx*vx + vy*vy + vz*vz) + f;	// distance along camera's z-axis
			var h	:Float = __vanishingPointY;
			var r	:Float = (180/Math.PI);
			
			return Math.atan((((d / f) / z) * h) / d) * r * 2;
		}

	}
