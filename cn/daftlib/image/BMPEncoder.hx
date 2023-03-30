package cn.daftlib.image;
import openfl.display.BitmapData;
import openfl.errors.Error;
import openfl.utils.ByteArray;
import openfl.utils.Endian;

/**
 * ...
 * @author eric.lin
 */
@:final class BMPEncoder
{
	public function new() { }
	
	public function encode(bitmapData:BitmapData):ByteArray
	{
		// image/file properties
		var bmpWidth:Int = bitmapData.width;
		var bmpHeight:Int = bitmapData.height;
		var imageBytes:ByteArray = bitmapData.getPixels(bitmapData.rect);
		var imageSize:Int = imageBytes.length;
		var imageDataOffset:Int = 0x36;
		var fileSize:Int = imageSize + imageDataOffset;
		// binary BMP data
		var bmpBytes:ByteArray = new ByteArray();
		bmpBytes.endian = Endian.LITTLE_ENDIAN; // byte order
		// header information
		#if (flash || js)
		bmpBytes.length = fileSize;
		#else
		bmpBytes.setLength(fileSize); //equal bmpBytes.length??
		#end
		bmpBytes.writeByte(0x42); // B
		bmpBytes.writeByte(0x4D); // M (BMP identifier)
		bmpBytes.writeInt(fileSize); // file size
		bmpBytes.position = 0x0A; // offset to image data
		bmpBytes.writeInt(imageDataOffset);
		bmpBytes.writeInt(0x28); // header size
		bmpBytes.position = 0x12; // width, height
		bmpBytes.writeInt(bmpWidth);
		bmpBytes.writeInt(bmpHeight);
		bmpBytes.writeShort(1); // planes (1)
		bmpBytes.writeShort(32); // color depth (32 bit)
		bmpBytes.writeInt(0); // compression type
		bmpBytes.writeInt(imageSize); // image data size
		bmpBytes.position = imageDataOffset; // start of image data...
		// write pixel bytes in upside-down order
		// (as per BMP format)
		var col:Int = bmpWidth;
		var row:Int = bmpHeight;
		var rowLength:Int = col * 4; // 4 bytes per pixel (32 bit)
		try
		{
			// make sure we're starting at the
			// beginning of the image data
			imageBytes.position = 0;
			// bottom row up
			while((row--)>0)
			{
				// from end of file up to imageDataOffset
				bmpBytes.position = imageDataOffset + row * rowLength;
				// read through each column writing
				// those bits to the image in normal
				// left to rightorder
				col = bmpWidth;
				while((col--)>0)
				{
					bmpBytes.writeInt(imageBytes.readInt());
				}
			}
		}
		catch(error:Error)
		{
			// end of file
		}
		// return BMP file
		return bmpBytes;
	}
}