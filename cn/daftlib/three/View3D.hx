package cn.daftlib.three;

	import flash.events.Event;
	
	import cn.daftlib.display.DaftSprite;
	import cn.daftlib.three.geom.Face;
	import cn.daftlib.three.geom.Object3D;
	import cn.daftlib.three.material.Material;
	import cn.daftlib.three.objects.PointCamera;
	import cn.daftlib.three.uitls.FaceUtil;
	import cn.daftlib.three.uitls.MaterialUtil;
	import cn.daftlib.three.uitls.ProjectionUtil;
	import cn.daftlib.three.uitls.TextureUtil;

	class View3D extends DaftSprite
	{
		private var __camera:PointCamera;
		private var __meshList:Array<Object3D>;
		
		private var __facesRendered:Int = 0;
		private var __facesTotal:Int = 0;
		
		public function new(centerX:Float, centerY:Float)
		{
			super();
			
			__meshList=[];
			__camera=new PointCamera(centerX, centerY);
		}
		public function get_meshesTotal():Int
		{
			return __meshList.length;
		}
		public function get_facesRendered():Int
		{
			return __facesRendered;
		}
		public function get_facesTotal():Int
		{
			return __facesTotal;
		}
		public function get_camera():PointCamera
		{
			return __camera;
		}
		
		public function addChild3D(child:Object3D):Void
		{
			__meshList.push(child);
		}
		public function startRendering():Void
		{
			this.addEventListener(Event.ENTER_FRAME, onRenderTick);
		}
		public function stopRendering():Void
		{
			this.removeEventListener(Event.ENTER_FRAME, onRenderTick);
		}
		override public function destroy():Void
		{
			stopRendering();
			
			super.destroy();
		}
		
		private function onRenderTick(e:Event):Void
		{
			var faceList:Array<Face> = ProjectionUtil.project(__meshList, __camera);
			__facesRendered = 0;
			
			this.graphics.clear();
			//this.graphics.lineStyle(2, 0x0, 1);
			//this.graphics.beginFill(0xff0000, .5);
			
			var curFace:Face;
			var curMaterial:Material;
			var curColor:Int;
			var faceIndex:Int = 0;
			
			__facesTotal = faceList.length;
			
			while(faceIndex<__facesTotal)
			{
				curFace = faceList[faceIndex];
				curMaterial = curFace.material;
				
				if( (curMaterial.doubleSided || !FaceUtil.isBackFace(curFace)) && FaceUtil.isFaceWithinCamera(curFace, __camera) ) 
				{
					++__facesRendered;
					
					//if(dynamicLighting && curMaterial.calculateLights)
					if(curMaterial.calculateLights)
					{
						//curColor = MaterialUtil.getColor(curMaterial.color, curFace, __camera);
					}
					else
					{
						curColor = curMaterial.color;
					}
					
					//if(curFace.material.texture == null || wireFrameMode)
					if(curFace.material.texture == null)
					{ 
						// render solid
						
						/*if(wireFrameMode)
						{
							curStage.graphics.lineStyle(1, 0xFFFFFF, 1);
						}
						else*/
						{
							this.graphics.beginFill(curColor, curMaterial.alpha);
						}
						
						this.graphics.moveTo(curFace.vertex1.screenX, curFace.vertex1.screenY);
						this.graphics.lineTo(curFace.vertex2.screenX, curFace.vertex2.screenY);
						this.graphics.lineTo(curFace.vertex3.screenX, curFace.vertex3.screenY);
						this.graphics.lineTo(curFace.vertex1.screenX, curFace.vertex1.screenY);
						this.graphics.endFill();
					}
					else
					{ 
						// render texture
						/*if(curMaterial.isSprite) // draw normal 2d sprite
						{ 
							Texture.render2DSprite(curStage, curMaterial.texture, curFace.v1);
						}
						else */// texture mapping
						{
							var ambientColor:Int = 0x000000;
							var ambientColorCorrection:Float = 0.0;
							TextureUtil.renderUV(this, curMaterial, curFace, (curColor / curMaterial.color) + ambientColorCorrection, ambientColor);
						}
					}
				}
				
				faceIndex++;
			}
		}
	}
