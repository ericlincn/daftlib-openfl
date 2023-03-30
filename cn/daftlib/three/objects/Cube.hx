package cn.daftlib.three.objects;

	import cn.daftlib.three.geom.Face;
	import cn.daftlib.three.geom.UV;
	import cn.daftlib.three.geom.Vertex;
	import cn.daftlib.three.material.Material;
	
	class Cube extends Mesh
	{
		public function new(width:Float, height:Float, depth:Float, materialList:Array<Material>)
		{
			super();
			 
			// front 4 points
			var v0:Vertex = new Vertex(-width*.5, -height*.5, -depth*.5);
			var v1:Vertex = new Vertex( width*.5, -height*.5, -depth*.5);
			var v2:Vertex = new Vertex( width*.5, height*.5, -depth*.5);
			var v3:Vertex = new Vertex(-width*.5, height*.5, -depth*.5);
			// back 4 points
			var v4:Vertex = new Vertex(-width*.5, -height*.5, depth*.5);
			var v5:Vertex = new Vertex( width*.5, -height*.5, depth*.5);
			var v6:Vertex = new Vertex( width*.5, height*.5, depth*.5);
			var v7:Vertex = new Vertex(-width*.5, height*.5, depth*.5);
			
			// front
			addFace(new Face(v0, v2, v1, materialList[0], [new UV(0, 0), new UV(1, 1), new UV(1, 0)]));
			addFace(new Face(v0, v3, v2, materialList[0], [new UV(0, 0), new UV(0, 1), new UV(1, 1)]));
			// top
			addFace(new Face(v0, v1, v5, materialList[1], [new UV(0, 0), new UV(1, 0), new UV(1, 1)]));
			addFace(new Face(v0, v5, v4, materialList[1], [new UV(0, 0), new UV(1, 1), new UV(0, 1)]));
			// back
			addFace(new Face(v4, v5, v6, materialList[2], [new UV(0, 0), new UV(0, 1), new UV(1, 1)]));
			addFace(new Face(v4, v6, v7, materialList[2], [new UV(0, 0), new UV(1, 1), new UV(1, 0)]));
			// bottom
			addFace(new Face(v3, v6, v2, materialList[3], [new UV(0, 0), new UV(1, 1), new UV(1, 0)]));
			addFace(new Face(v3, v7, v6, materialList[3], [new UV(0, 0), new UV(0, 1), new UV(1, 1)]));
			// right
			addFace(new Face(v1, v6, v5, materialList[4], [new UV(0, 0), new UV(1, 1), new UV(0, 1)]));
			addFace(new Face(v1, v2, v6, materialList[4], [new UV(0, 0), new UV(1, 0), new UV(1, 1)]));
			// left
			addFace(new Face(v4, v3, v0, materialList[5], [new UV(0, 0), new UV(1, 1), new UV(0, 1)]));
			addFace(new Face(v4, v7, v3, materialList[5], [new UV(0, 0), new UV(1, 0), new UV(1, 1)]));
			
			
		}
	}
