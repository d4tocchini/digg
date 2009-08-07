/*
 * vim:et sts=4 sw=4 cindent tw=120:
 * $Id: HSV.as,v 1.4 2006-08-14 19:31:55 allens Exp $
 */

package com.stamen.graphics.color
{
	import com.stamen.graphics.color.*;
	
	public class HSV extends Color implements IColor
	{
	    // 0-360
	    public var hue:int = 0;
	    // 0-1
	    public var sat:Number = 0;
	    // 0-1
	    public var value:Number = 0;
	
	    public static function black():HSV
	    {
	        return new HSV(0, 0, 0);
	    }

	    public static function white():HSV
	    {
	        return new HSV(0, 0, 1);
	    }
	
	    public static function grey(value:Number):HSV
	    {
	        return new HSV(0, 0, value);
	    }
	
	    public static function random():HSV
	    {
	        return new HSV(Math.random() * 360,
	                       Math.random(),
	                       Math.random());
	    }
	
	    public static function fromHex(hex:*):HSV
	    {
	        return RGB.fromHex(hex).toHSV();
	    }
	
	    public function HSV(hue:int=0, sat:Number=1, value:Number=1)
	    {
	        this.hue = hue;
	        this.sat = sat;
	        this.value = value;
	    }
	
	    public function copy():IColor
	    {
	        return new HSV(hue, sat, value);
	    }

		public function equals(color:IColor):Boolean
		{
			return color && (color.toHex() == toHex() && color.alpha == alpha);
		}
	
	    public function toHSV():HSV
	    {
	        return HSV(copy());
	    }
	
	    public function toRGB():RGB
	    {
	        var r:Number, g:Number, b:Number;
	
	        if (sat == 0)
	        {
	            r = g = b = value;
	        }
	        else
	        {
	            var hue:Number = hue / 360;
	            hue = (hue * 6) % 6;
	
	            var i:Number = Math.floor(hue);
	
	            var v1:Number = value * (1 - sat);
	            var v2:Number = value * (1 - sat * (hue - i));
	            var v3:Number = value * (1 - sat * (1 - (hue - i)));
	
	            switch (i)
	            {
	                case 0:
	                    r = value;
	                    g = v3;
	                    b = v1;
	                    break;
	
	                case 1:
	                    r = v2;
	                    g = value;
	                    b = v1;
	                    break;
	
	                case 2:
	                    r = v1;
	                    g = value;
	                    b = v3;
	                    break;
	
	                case 3:
	                    r = v1;
	                    g = v2;
	                    b = value;
	                    break;
	
	                case 4:
	                    r = v3;
	                    g = v1;
	                    b = value;
	                    break;
	
	                default:
	                    r = value;
	                    g = v1;
	                    b = v2;
	                    break;
	            }
	        }
	
	        r *= 255;
	        g *= 255;
	        b *= 255;
			return new RGB(r, g, b);
	    }
	
		public function invert():HSV
		{
			var inverted:HSV = new HSV(hue % 360, sat, value);
			inverted.hue = 360 - inverted.hue;
			inverted.value = 1 - inverted.value;
			return inverted;
		}
	
	    public function blend(color:IColor, amount:Number=0.5, asRGB:Boolean=false):IColor
	    {
	        if (asRGB)
	        {
	            return toRGB().blend(color.toRGB(), amount, true).toHSV();
	        }
	        else
	        {
	            var parts:Array = _blend(color, amount);
	            return new HSV(parts[0], parts[1], parts[2]);
	        }
	    }
	
	    public function toString():String
	    {
	        var rgb:RGB = toRGB();
	        return rgb.toString();
	    }
	
	    public function toHex(withAlpha:Boolean=false):int
	    {
	        var rgb:RGB = toRGB();
	        return rgb.toHex(withAlpha);
	    }

		public function toRGBA(alpha:Number=1.0):RGBA
		{
			return toRGB().toRGBA(alpha);
		}

		public function toHSVA(alpha:Number=1.0):HSVA
		{
			return HSVA.fromHSV(toHSV(), alpha);
		}

	    override public function toArray():Array
	    {
	        return [hue, sat, value];
	    }
	}
}