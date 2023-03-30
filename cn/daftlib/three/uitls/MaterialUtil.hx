package cn.daftlib.three.uitls;

	import cn.daftlib.three.geom.Face;
	import cn.daftlib.three.geom.Vertex;
	import cn.daftlib.three.objects.PointCamera;

	class MaterialUtil
	{
		public static function getColor(color:Int, face:Face, camera:PointCamera):Float 
		{
			// dynamic lighting
			var r:Float = color >> 16;
			var g:Float = color >> 8 & 0xFF;
			var b:Float = color & 0xFF;
			
			var lightVertex:Vertex = new Vertex(camera.x, camera.y, camera.z - camera.zOffset);
			
			var v1:Vertex = new Vertex(face.vertex1.x3d - face.vertex2.x3d, face.vertex1.y3d - face.vertex2.y3d, face.vertex1.z3d - face.vertex2.z3d);
			var v2:Vertex = new Vertex(face.vertex2.x3d - face.vertex3.x3d, face.vertex2.y3d - face.vertex3.y3d, face.vertex2.z3d - face.vertex3.z3d);
			
			var norm:Vertex = v1.cross(v2);
			
			var lightIntensity:Float = norm.dot(lightVertex);
			var normMag:Float = norm.length;
			var lightMag:Float = lightVertex.length;
			
			var factor:Float = (Math.acos(lightIntensity / (normMag * lightMag)) / Math.PI); 
			
			r *= factor;
			g *= factor;
			b *= factor;
			
			return (Std.int(r) << 16 | Std.int(g) << 8 | Std.int(b));
		}
	}
