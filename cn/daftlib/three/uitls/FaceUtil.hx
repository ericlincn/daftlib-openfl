package cn.daftlib.three.uitls;

	import cn.daftlib.three.geom.Face;
	import cn.daftlib.three.objects.PointCamera;

	class FaceUtil
	{
		public static function isBackFace(face:Face):Bool
		{
			var cax:Float = face.vertex3.screenX - face.vertex1.screenX;
			var cay:Float = face.vertex3.screenY - face.vertex1.screenY;
			var bcx:Float = face.vertex2.screenX - face.vertex3.screenX;
			var bcy:Float = face.vertex2.screenY - face.vertex3.screenY;
			return ( cax * bcy - cay * bcx ) > 0;
		}
		public static function isFaceWithinCamera(face:Face, camera:PointCamera):Bool
		{
			return (face.vertex1.z3d > -camera.focalLength - camera.zOffset) && (face.vertex2.z3d > -camera.focalLength - camera.zOffset) && (face.vertex3.z3d > -camera.focalLength - camera.zOffset);
		}
	}
