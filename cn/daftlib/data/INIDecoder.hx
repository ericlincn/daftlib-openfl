package cn.daftlib.data;
import cn.daftlib.utils.ReflectUtil;

/**
 * ...
 * @author ...
 */
@:final class INIDecoder
{
	public function new(){}
	public function decode(str:String):Dynamic
	{
		var obj:Dynamic = {};
		var sectionKey:String = null;

		var reg:EReg = ~/\r?\n/g;
		var lines:Array<String> = reg.split(str);
		//var lines:Array = str.split(/\r?\n/);
		var i:Int = 0;
		while(i < lines.length)
		{
			var line:String = lines[i];
			if(isComments(line))
			{
				//do nothing
			}
			else if(isSection(line))
			{
				sectionKey=getSection(line);
			}
			else if(isKey(line))
			{
				var key:String=getKey(line)[0];
				var value:String=getKey(line)[1];
				if(value.length == 0)
					value = null;
				
				if(sectionKey == null)
				{
					ReflectUtil.setField(obj, key, value);
					//obj[key]=value;
				}
				else
				{
					/*if(obj[sectionKey] == undefined)
						obj[sectionKey] = {};
					
					obj[sectionKey][key] = value;*/
					
					if (ReflectUtil.getField(obj, sectionKey) == null)
						ReflectUtil.setField(obj, sectionKey, { } );
					
					ReflectUtil.setField(ReflectUtil.getField(obj, sectionKey), key, value);
				}
				
				//trace(i, "-----", sectionKey,"-----", key, "-----",value);
			}

			i++;
		}

		return obj;
	}
	private function isComments(line:String):Bool
	{
		var whiteLess:String=removeWhitespace(line);
		return whiteLess.indexOf(";")==0;
	}
	private function isSection(line:String):Bool
	{
		var whiteLess:String=removeWhitespace(line);
		return whiteLess.indexOf("[")==0 && whiteLess.indexOf("]")>1;
	}
	private function isKey(line:String):Bool
	{
		var whiteLess:String=removeWhitespace(line);
		return whiteLess.indexOf("=")>1;
	}
	private function getSection(line:String):String
	{
		var section:String=removeWhitespace(line);
		var firstIndex:Int=section.indexOf("[");
		var lastIndex:Int=section.lastIndexOf("]");
		section = section.substring(firstIndex+1, lastIndex);
		return section;
	}
	private function getKey(line:String):Array<String>
	{
		var out:Array<String>=[];
		var firstIndex:Int=line.indexOf("=");
		var key:String=line.substr(0, firstIndex);
		out.push(removeWhitespace(key));
		out.push(line.substr(firstIndex+1, line.length));
		return out;
	}
	private function removeWhitespace(source:String):String
	{
		//var pattern:RegExp = new RegExp('[ \n\t\r]', 'g');
		//return source.replace(pattern, '');
		var pattern:EReg = new EReg('[ \n\t\r]', 'g');
		return pattern.replace(source, '');
	}
}