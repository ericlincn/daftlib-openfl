package cn.daftlib.image;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

/**
 * ...
 * @author eric.lin
 */
@:final class PNGEncoder
{
	private static var __crcTable:Array<Int>;
	
	public function new() { }
	
	public function encode(bitmapData:BitmapData):ByteArray
	{
		//var crcTable:Array<Int> = initializeCRCTable();
		if (__crcTable == null)
		__crcTable = initializeCRCTable();
		
		var pngWidth:Int = bitmapData.width;
		var pngHeight:Int = bitmapData.height;
		var transparent:Bool = bitmapData.transparent;
		
		var sourceBitmapData:BitmapData = bitmapData;
		
		// Create output byte array
		var png:ByteArray = new ByteArray();
		
		// Write PNG signature
		png.writeUnsignedInt(0x89504E47);
		png.writeUnsignedInt(0x0D0A1A0A);
		
		// Build IHDR chunk
		var IHDR:ByteArray = new ByteArray();
		IHDR.writeInt(pngWidth);
		IHDR.writeInt(pngHeight);
		IHDR.writeByte(8); // bit depth per channel
		IHDR.writeByte(6); // color type: RGBA
		IHDR.writeByte(0); // compression method
		IHDR.writeByte(0); // filter method
		IHDR.writeByte(0); // interlace method
		writeChunk(png, 0x49484452, IHDR, __crcTable);
		
		// Build IDAT chunk
		var IDAT:ByteArray = new ByteArray();
		for(y in 0...pngHeight)
		{
			IDAT.writeByte(0); // no filter
			
			//var x:Int;
			var pixel:Int;
			
			if(transparent == false)
			{
				for(x in 0...pngWidth)
				{
					//if(sourceBitmapData != null)
						pixel = sourceBitmapData.getPixel(x, y);
					
					IDAT.writeUnsignedInt(((pixel & 0xFFFFFF) << 8) | 0xFF);
				}
			}
			else
			{
				for(x in 0...pngWidth)
				{
					//if(sourceBitmapData != null)
						pixel = sourceBitmapData.getPixel32(x, y);
					
					IDAT.writeUnsignedInt(((pixel & 0xFFFFFF) << 8) | (pixel >>> 24));
				}
			}
		}
		IDAT.compress();
		writeChunk(png, 0x49444154, IDAT, __crcTable);
		
		// Build IEND chunk
		writeChunk(png, 0x49454E44, null, __crcTable);
		
		// return PNG
		png.position = 0;
		return png;
	}
	private function initializeCRCTable():Array<Int>
	{
		var crcTable:Array<Int> = [];
		
		for(n in 0...256)
		{
			var c:Int = n;
			for(k in 0...8)
			{
				//if(c & 1)
				if(1 == c & 1)
					c = 0xedb88320 ^ (c >>> 1);
				else
					c = c >>> 1;
			}
			crcTable[n] = c;
		}
		
		return crcTable;
	}
	private function writeChunk(png:ByteArray, type:Int, data:ByteArray, crcTable:Array<Int>):Void
	{
		// Write length of data.
		var len:Int = 0;
		if(data != null)
			len = data.length;
		png.writeUnsignedInt(len);
		
		// Write chunk type.
		var typePos:Int = png.position;
		png.writeUnsignedInt(type);
		
		// Write data.
		if(data != null)
			png.writeBytes(data);
		
		// Write CRC of chunk type and data.
		var crcPos:Int = png.position;
		png.position = typePos;
		var crc:Int = 0xFFFFFFFF;
		for(i in typePos...crcPos)
		{
			crc = crcTable[(crc ^ png.readUnsignedByte()) & 0xFF] ^ (crc >>> 8);
		}
		crc = crc ^ 0xFFFFFFFF;
		png.position = crcPos;
		png.writeUnsignedInt(crc);
	}
}