package cn.daftlib.three.uitls;

	import cn.daftlib.three.geom.Face;
	import cn.daftlib.three.geom.Vertex;
	import cn.daftlib.three.objects.Mesh;
	import cn.daftlib.three.objects.PointCamera;
	import cn.daftlib.utils.GeomUtil;

	class ProjectionUtil
	{ 
		public static function project(meshList:Array<Mesh>, camera:PointCamera):Array<Face>
		{
			var camRotoX:Float=GeomUtil.degreesToRadians(camera.rotationX);
			var camRotoY:Float=GeomUtil.degreesToRadians(camera.rotationY);
			var camRotoZ:Float=GeomUtil.degreesToRadians(camera.rotationZ);
			
			// cam rotation
			var cosZ:Float = Math.cos(camRotoZ);
			var sinZ:Float = Math.sin(camRotoZ);
			var cosY:Float = Math.cos(camRotoY);
			var sinY:Float = Math.sin(camRotoY);
			var cosX:Float = Math.cos(camRotoX);
			var sinX:Float = Math.sin(camRotoX);
			/*
			// the quarternion way...			
			var tmpQuat:Quaternion = new Quaternion();
			tmpQuat.eulerToQuaternion(-cam.deltaAngleX, -cam.deltaAngleY, -cam.deltaAngleZ);
			cam.quaternion.concat(tmpQuat);
			cam.deltaAngleX = 0;
			cam.deltaAngleY = 0;
			cam.deltaAngleZ = 0;
			*/
			// local rotation
			/**/
			var cosZMesh:Float;
			var sinZMesh:Float;
			var cosYMesh:Float;
			var sinYMesh:Float;
			var cosXMesh:Float;
			var sinXMesh:Float;
			
			var i:Int = meshList.length;
			var j:Int;
			var curMesh:Mesh;
			var curVertex:Vertex;
			var x:Float;
			var y:Float;
			var x1:Float;
			var x2:Float;
			var x3:Float;
			var x4:Float;
			var y1:Float;
			var y2:Float;
			var y3:Float;
			var y4:Float;
			var z1:Float;
			var z2:Float;
			var z3:Float;
			var z4:Float;
			var scale:Float;
			var faceList:Array<Face> = [];
			var vertexList:Array<Vertex> = [];
			
			var meshRotoX:Float;
			var meshRotoY:Float;
			var meshRotoZ:Float;
			
			while(--i > -1) 
			{ 
				// step through meshes
				
				curMesh = meshList[i];
				
				faceList = faceList.concat(curMesh.faceList);
				vertexList = curMesh.vertexList;
				
				j = vertexList.length;
				
				meshRotoX = GeomUtil.degreesToRadians(curMesh.rotationX);
				meshRotoY = GeomUtil.degreesToRadians(curMesh.rotationY);
				meshRotoZ = GeomUtil.degreesToRadians(curMesh.rotationZ);
				
				cosZMesh = Math.cos(meshRotoZ);
				sinZMesh = Math.sin(meshRotoZ);
				cosYMesh = Math.cos(meshRotoY);
				sinYMesh = Math.sin(meshRotoY);
				cosXMesh = Math.cos(meshRotoX);
				sinXMesh = Math.sin(meshRotoX);
				
				/*
				// rotation
				// the quarternion way...
				tmpQuat = new Quaternion();
				tmpQuat.eulerToQuaternion(curMesh.deltaAngleX, curMesh.deltaAngleY, curMesh.deltaAngleZ);
				curMesh.quaternion.concat(tmpQuat);
				curMesh.deltaAngleX = 0;
				curMesh.deltaAngleY = 0;
				curMesh.deltaAngleZ = 0;
				*/
				while(--j > -1) 
				{ 
					// step through vertexlist
					
					curVertex = vertexList[j];
					/*					
					// the quarternion way...
					tmpVertex = curVertex.clone();
					tmpVertex = curVertex.rotatePoint(curMesh.quaternion);
					x2 = tmpVertex.x;
					y2 = tmpVertex.y;
					z2 = tmpVertex.z;
					*/					
					// local coordinate rotation x,y,z					
					// z axis
					x1 = (curVertex.x * curMesh.scaleX) * cosZMesh - (curVertex.y * curMesh.scaleY) * sinZMesh;
					y1 = (curVertex.y * curMesh.scaleY) * cosZMesh + (curVertex.x * curMesh.scaleX) * sinZMesh;
					// y axis
					x2 = x1 * cosYMesh - (curVertex.z * curMesh.scaleZ) * sinYMesh;
					z1 = (curVertex.z * curMesh.scaleZ) * cosYMesh + x1 * sinYMesh;
					// x axis
					y2 = y1 * cosXMesh - z1 * sinXMesh;
					z2 = z1 * cosXMesh + y1 * sinXMesh;
					
					// local coordinate movement
					x2 += curMesh.x;
					y2 += curMesh.y;
					z2 += curMesh.z;
					
					// camera movement -minus because we must get to 0,0,0
					x2 -= camera.x;
					y2 -= camera.y;
					z2 -= camera.z;
					
					// camera view rotation x,y,z
					x3 = x2 * cosZ - y2 * sinZ;
					y3 = y2 * cosZ + x2 * sinZ;
					
					x4 = x3 * cosY - z2 * sinY;
					z3 = z2 * cosY + x3 * sinY;
					
					y4 = y3 * cosX - z3 * sinX;
					z4 = z3 * cosX + y3 * sinX;
					/*
					// the quarternion way...
					tmpVertex = new Vertex(x2, y2, z2);
					tmpVertex = tmpVertex.rotatePoint(cam.quaternion);
					x4 = tmpVertex.x;
					y4 = tmpVertex.y;
					z4 = tmpVertex.z;
					*/					
					// final screen coordinates (3d to 2d)
					scale = camera.focalLength / (camera.focalLength + z4 + camera.zOffset);
					x = camera.vanishingPointX + x4 * scale;
					y = camera.vanishingPointY + y4 * scale;
					
					curVertex.screenX = x;
					curVertex.screenY = y;
					// for texture
					curVertex.scale = scale;
					
					// for lighting
					curVertex.x3d = x4;
					curVertex.y3d = y4;
					curVertex.z3d = z4;
				}
			}
			
			// sort
			faceList = faceList.sort(faceZSort);
			
			return faceList;
		}
		private static function faceZSort(fa:Face, fb:Face):Int 
		{
			var za:Float = (fa.vertex1.z3d + fa.vertex2.z3d + fa.vertex3.z3d) / 3;
			var zb:Float = (fb.vertex1.z3d + fb.vertex2.z3d + fb.vertex3.z3d) / 3;
			
			if(za > zb) 
			{
				return -1;
			}
			else 
			{
				return 1;
			}
		}
	}
