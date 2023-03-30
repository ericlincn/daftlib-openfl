package cn.daftlib.color;

/**
 * ...
 * @author eric.lin
 */
@:final class HSV implements IColor
{
	public var value(get, set):Int;
	public var h(get, set):Float;
	public var s(get, set):Float;
	public var v(get, set):Float;
	
	private var _h:Float; //Hue
	private var _s:Float; //Saturation
	private var _v:Float; //Brightness
	private var _r:Int;
	private var _g:Int;
	private var _b:Int;
	
	public function new(h:Float = 0.0, s:Float = 1.0, v:Float = 1.0) 
	{
		set_h(h);
		set_s(s);
		set_v(v);
	}
	private function get_value():Int
	{
		updateHSVtoRGB();
		
		return _r << 16 | _g << 8 | _b;
	}
	private function set_value(value:Int):Int
	{
		_r = value >> 16;
		_g = (value & 0x00ff00) >> 8;
		_b = value & 0x0000ff;
		
		updateRGBtoHSV();
		
		return 0;
	}
	
	/**
	 * The value of Hue, like a angle in a color wheel( 0~360 ).<br/>
	 * 0 is red, 120 is green、240 is blue.
	 */
	private function get_h():Float
	{
		return _h;
	}
	private function set_h(value:Float):Float
	{
		return _h = value;
	}

	/**
	 * The value of Saturation.<br/>
	 * Between 0.0 ~ 1.0 , Default is 1.
	 */
	private function get_s():Float
	{
		return _s;
	}
	private function set_s(value:Float):Float
	{
		return _s = Math.max(0.0, Math.min(1.0, value));
	}

	/**
	 * The value of Brightness.<br/>
	 * Between 0.0 ~ 1.0 , Default is 1.
	 */
	private function get_v():Float
	{
		return _v;
	}
	private function set_v(value:Float):Float
	{
		return _v = Math.max(0.0, Math.min(1.0, value));
	}

	private function updateHSVtoRGB():Void
	{
		if(_s > 0)
		{
			var h:Float = ((_h < 0) ? _h % 360 + 360 : _h % 360) / 60;
			if(h < 1)
			{
				_r = Math.round(255 * _v);
				_g = Math.round(255 * _v * (1 - _s * (1 - h)));
				_b = Math.round(255 * _v * (1 - _s));
			}
			else if(h < 2)
			{
				_r = Math.round(255 * _v * (1 - _s * (h - 1)));
				_g = Math.round(255 * _v);
				_b = Math.round(255 * _v * (1 - _s));
			}
			else if(h < 3)
			{
				_r = Math.round(255 * _v * (1 - _s));
				_g = Math.round(255 * _v);
				_b = Math.round(255 * _v * (1 - _s * (3 - h)));
			}
			else if(h < 4)
			{
				_r = Math.round(255 * _v * (1 - _s));
				_g = Math.round(255 * _v * (1 - _s * (h - 3)));
				_b = Math.round(255 * _v);
			}
			else if(h < 5)
			{
				_r = Math.round(255 * _v * (1 - _s * (5 - h)));
				_g = Math.round(255 * _v * (1 - _s));
				_b = Math.round(255 * _v);
			}
			else
			{
				_r = Math.round(255 * _v);
				_g = Math.round(255 * _v * (1 - _s));
				_b = Math.round(255 * _v * (1 - _s * (h - 5)));
			}
		}
		else
		{
			_r = _g = _b = Math.round(255 * _v);
		}
	}
	private function updateRGBtoHSV():Void
	{
		if(_r != _g || _r != _b)
		{
			if(_g > _b)
			{
				if(_r > _g)
				{ //r>g>b
					_v = _r / 255;
					_s = (_r - _b) / _r;
					_h = 60 * (_g - _b) / (_r - _b);
				}
				else if(_r < _b)
				{ //g>b>r
					_v = _g / 255;
					_s = (_g - _r) / _g;
					_h = 60 * (_b - _r) / (_g - _r) + 120;
				}
				else
				{ //g=>r=>b
					_v = _g / 255;
					_s = (_g - _b) / _g;
					_h = 60 * (_b - _r) / (_g - _b) + 120;
				}
			}
			else
			{
				if(_r > _b)
				{ // r>b=>g
					_v = _r / 255;
					_s = (_r - _g) / _r;
					_h = 60 * (_g - _b) / (_r - _g);
					if(_h < 0)
						_h += 360;
				}
				else if(_r < _g)
				{ //b=>g>r
					_v = _b / 255;
					_s = (_b - _r) / _b;
					_h = 60 * (_r - _g) / (_b - _r) + 240;
				}
				else
				{ //b=>r=>g
					_v = _b / 255;
					_s = (_b - _g) / _b;
					_h = 60 * (_r - _g) / (_b - _g) + 240;
				}
			}
		}
		else
		{
			_h = _s = 0;
			_v = _r / 255;
		}
	}
}