package cn.daftlib.text;
import openfl.text.Font;
import openfl.text.FontType;

/**
 * NOT AVAILABLE IN HTML5 TARGET
 * @author eric.lin
 */
@:final class FontLibrary
{
	public static function getRegistedFonts(embedded:Bool = true):Array<String> 
	{
		var out:Array<String> = [];
		var arr:Array<Font> = Font.enumerateFonts(!embedded);
		//arr.sortOn("fontName", Array.CASEINSENSITIVE);
		arr.sort(sortByFontName);
		
		var i:Int = 0;
		while(i < arr.length)
		{
			if (arr[i].fontType != FontType.EMBEDDED || embedded == true)
			{
				if (out.indexOf(arr[i].fontName) < 0)
					out.push(arr[i].fontName);
			}
			i++;
		}
		return out;
	}
	private static function sortByFontName(fontA:Font, fontB:Font):Int
	{
		if (fontA.fontName.toLowerCase() > fontB.fontName.toLowerCase())
			return 1;
		else if (fontA.fontName.toLowerCase() < fontB.fontName.toLowerCase())
			return -1;
		
		return 0;
	}
}