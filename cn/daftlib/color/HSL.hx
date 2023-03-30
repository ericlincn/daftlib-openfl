package cn.daftlib.color;

/**
 * ...
 * @author eric.lin
 */
@:final class HSL implements IColor
{
	public var value(get, set):Int;
	public var h(get, set):Float;
	public var s(get, set):Float;
	public var l(get, set):Float;
	
	private var _h:Float; //Hue
	private var _s:Float; //Saturation
	private var _l:Float; //Lightness
	private var _r:Int;
	private var _g:Int;
	private var _b:Int;
	
	public function new(h:Float = 0.0, s:Float = 1.0, l:Float = 0.5) 
	{
		set_h(h);
		set_s(s);
		set_l(l);
	}
	private function get_value():Int
	{
		updateHSLtoRGB();
		
		return _r << 16 | _g << 8 | _b;
	}
	private function set_value(value:Int):Int
	{
		_r = value >> 16;
		_g = (value & 0x00ff00) >> 8;
		_b = value & 0x0000ff;
		
		updateRGBtoHSL();
		
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
	 * The value of Lightness.<br/>
	 * Between 0.0 ~ 1.0 , Default is 1.
	 */
	private function get_l():Float
	{
		return _l;
	}
	private function set_l(value:Float):Float
	{
		return _l = Math.max(0.0, Math.min(1.0, value));
	}

	private function updateHSLtoRGB():Void
	{
		if(_s > 0)
		{
			var v:Float = (_l <= 0.5) ? _l + _s * _l : _l + _s * (1 - _l);
			var p:Float = 2.0 * _l - v;
			var h:Float = ((_h < 0) ? _h % 360 + 360 : _h % 360) / 60;
			if(h < 1)
			{
				_r = Math.round(255 * v);
				_g = Math.round(255 * (p + (v - p) * h));
				_b = Math.round(255 * p);
			}
			else if(h < 2)
			{
				_r = Math.round(255 * (p + (v - p) * (2 - h)));
				_g = Math.round(255 * v);
				_b = Math.round(255 * p);
			}
			else if(h < 3)
			{
				_r = Math.round(255 * p);
				_g = Math.round(255 * v);
				_b = Math.round(255 * (p + (v - p) * (h - 2)));
			}
			else if(h < 4)
			{
				_r = Math.round(255 * p);
				_g = Math.round(255 * (p + (v - p) * (4 - h)));
				_b = Math.round(255 * v);
			}
			else if(h < 5)
			{
				_r = Math.round(255 * (p + (v - p) * (h - 4)));
				_g = Math.round(255 * p);
				_b = Math.round(255 * v);
			}
			else
			{
				_r = Math.round(255 * v);
				_g = Math.round(255 * p);
				_b = Math.round(255 * (p + (v - p) * (6 - h)));
			}
		}
		else
		{
			_r = _g = _b = Math.round(255 * _l);
		}
	}
	private function updateRGBtoHSL():Void
	{
		if(_r != _g || _r != _b)
		{
			if(_g > _b)
			{
				if(_r > _g)
				{ //r>g>b
					_l = (_r + _b);
					_s = (_l > 255) ? (_r - _b) / (510 - _l) : (_r - _b) / _l;
					_h = 60 * (_g - _b) / (_r - _b);
				}
				else if(_r < _b)
				{ //g>b>r
					_l = (_g + _r);
					_s = (_l > 255) ? (_g - _r) / (510 - _l) : (_g - _r) / _l;
					_h = 60 * (_b - _r) / (_g - _r) + 120;
				}
				else
				{ //g=>r=>b
					_l = (_g + _b);
					_s = (_l > 255) ? (_g - _b) / (510 - _l) : (_g - _b) / _l;
					_h = 60 * (_b - _r) / (_g - _b) + 120;
				}
			}
			else
			{
				if(_r > _b)
				{ // r>b=>g
					_l = (_r + _g);
					_s = (_l > 255) ? (_r - _g) / (510 - _l) : (_r - _g) / _l;
					_h = 60 * (_g - _b) / (_r - _g);
					if(_h < 0)
						_h += 360;
				}
				else if(_r < _g)
				{ //b=>g>r
					_l = (_b + _r);
					_s = (_l > 255) ? (_b - _r) / (510 - _l) : (_b - _r) / _l;
					_h = 60 * (_r - _g) / (_b - _r) + 240;
				}
				else
				{ //b=>r=>g
					_l = (_b + _g);
					_s = (_l > 255) ? (_b - _g) / (510 - _l) : (_b - _g) / _l;
					_h = 60 * (_r - _g) / (_b - _g) + 240;
				}
			}
			_l /= 510;
		}
		else
		{
			_h = _s = 0;
			_l = _r / 255;
		}
	}
}