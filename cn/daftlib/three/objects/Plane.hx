package cn.daftlib.three.objects;

	import cn.daftlib.three.geom.Face;
	import cn.daftlib.three.geom.UV;
	import cn.daftlib.three.geom.Vertex;
	import cn.daftlib.three.material.Material;

	class Plane extends Mesh
	{
		public function new(width:Float, height:Float, stepsX:Int, stepsY:Int, material:Material)
		{
			super();
			
			var i:Float;
			var j:Float;
			var ar:Array<Array<Vertex>> = [];
			
			width *= 2;
			height *= 2;
			
			//for(i = 0;i <= stepsX; i++)
			for(i in 0...stepsX)
			{
				ar.push([]);
				//for(j = 0;j <= stepsX; j++)
				for(j in 0...stepsX)
				{
					var x:Float = i * (width / stepsX) - width / 2;
					var y:Float = j * (height / stepsY) - height / 2;
					ar[i].push(new Vertex(x, y, 0));
				}
			}
			
			var xscaling:Float = 1 / stepsX;
			var yscaling:Float = 1 / stepsY;
			
			//for (i = 0; i < ar.length; i++)
			for(i in 0...ar.length)
			{
				//for(j = 0;j < ar[i].length; j++)
				for(j in 0...ar[i].length)
				{
					if(i > 0 && j > 0)
					{
						var uv1:Array<UV> = [new UV((i - 1) * xscaling, (j - 1) * yscaling), 
							new UV((i - 1) * xscaling, (j) * yscaling),
							new UV((i) * xscaling, (j) * yscaling)];
						
						var uv2:Array<UV> = [new UV((i - 1) * xscaling, (j - 1) * yscaling), 
							new UV((i) * xscaling, (j) * yscaling),
							new UV((i) * xscaling, (j - 1) * yscaling)];
						
						addFace(new Face(ar[i - 1][j - 1], ar[i - 1][j], ar[i][j], material, uv1));
						addFace(new Face(ar[i - 1][j - 1], ar[i][j], ar[i][j - 1], material, uv2));
					}
				}
			}
		}
	}
