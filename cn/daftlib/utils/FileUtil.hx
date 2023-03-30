package cn.daftlib.utils;
import openfl.utils.ByteArray;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author eric.lin
 */
@:final class FileUtil
{
	public static function readFile(filePath:String):ByteArray
	{
		if (FileSystem.exists(filePath) && !FileSystem.isDirectory(filePath))
		{
			var bytes:ByteArray = ByteArrayUtil.bytesToByteArray(File.getBytes(filePath));
			return bytes;
		}
		
		return null;
	}
	public static function writeFile(filePath:String, bytes:ByteArray):Void
	{
		File.write(filePath, false);
		File.saveBytes(filePath, ByteArrayUtil.byteArraytToBytes(bytes));
	}
	public static function getFilesURL(dirPath:String, recursive:Bool = false):Array<String>
	{
		/*internal file install folder
		SystemPath.applicationStorageDirectory;
		SD card root
		SystemPath.documentsDirectory;
		app download folder in SD card
		SystemPath.userDirectory;*/
		
		if(FileSystem.exists(dirPath) && FileSystem.isDirectory(dirPath))
		{
			var endWithSlash:Bool = dirPath.lastIndexOf("/") == (dirPath.length - 1);
			var tmp:Array<String> = FileSystem.readDirectory(dirPath);
			var result:Array<String> = [];
			var i:Int = 0;
			while(i<tmp.length)
			{
				var fullPath:String = dirPath + (endWithSlash == true?"":"/") +tmp[i];
				if (FileSystem.isDirectory(fullPath) == false)
				{
					result.push(fullPath);
				}
				else if (recursive == true)
				{
					result = result.concat(getFilesURL(fullPath));
				}
				
				i++;
			}
			
			return result;
		}
		
		return null;
	}
}