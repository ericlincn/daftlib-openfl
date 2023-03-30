package cn.daftlib.three.objects;

	import openfl.utils.Dictionary;
	
	import cn.daftlib.three.geom.Face;
	import cn.daftlib.three.geom.Object3D;
	import cn.daftlib.three.geom.Vertex;

	class Mesh extends Object3D
	{
		public var vertexList(get, null):Array<Vertex>;
		public var faceList(get, null):Array<Face>;
		
		private var __faceList:Array<Face>;
		private var __vertexList:Array<Vertex>;
		
		public function new()
		{
			super();
			
			__faceList = [];
			__vertexList = [];
		}
		public function addFace(face:Face):Void 
		{
			__faceList.push(face);
			//__vertexList.push(face.vertex1, face.vertex2, face.vertex3);
			__vertexList.push(face.vertex1);
			__vertexList.push(face.vertex2);
			__vertexList.push(face.vertex3);
		}

		public function get_vertexList():Array<Vertex>
		{
			return __vertexList;
		}

		public function get_faceList():Array<Face>
		{
			return __faceList;
		}
		
		private function optimizeVertices(tolerance:Float = 1):Void	
		{
			
			trace("before: " + __vertexList.length);
			
			var i:Int;
			var uniqueList:Map<Vertex, Vertex> = new Map<Vertex, Vertex>();
			var v:Vertex;
			var uniqueV:Vertex;
			var f:Face;
			
			// fill unique listing
			//for(i = 0;i < vertexList.length; i++) 
			for( i in 0...vertexList.length )
			{
				v = vertexList[i];
				uniqueList[v] = v;
			}
			
			// step through vertices and find duplicates vertices
			//for(i = 0;i < vertexList.length; i++) 
			for( i in 0...vertexList.length )
			{
				
				v = vertexList[i];
				
				//for each(uniqueV in uniqueList) 
				for( key in uniqueList.keys() )
				{
					uniqueV = uniqueList.get(key);
					if(	Math.abs(v.x - uniqueV.x) <= tolerance && Math.abs(v.y - uniqueV.y) <= tolerance && Math.abs(v.z - uniqueV.z) <= tolerance) 
					{
						
						uniqueList[v] = uniqueV; // replace vertice with unique one
					}
				}
			}
			
			__vertexList = [];
			
			//for each(f in faceList)	
			for( i in 0...faceList.length )
			{
				f = faceList[i];
				f.vertex1 = uniqueList[f.vertex1];
				f.vertex2 = uniqueList[f.vertex2];
				f.vertex3 = uniqueList[f.vertex3];
				
				vertexList.push(f.vertex1);
				vertexList.push(f.vertex2);
				vertexList.push(f.vertex3);
			}
			
			trace("after: " + vertexList.length);
		}
	}
