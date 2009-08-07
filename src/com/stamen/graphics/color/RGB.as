/*
 * vim:et sts=4 sw=4 cindent tw=120:
 * $Id: RGB.as,v 1.11 2006-08-14 19:31:55 allens Exp $
 */

package com.stamen.graphics.color
{
	import com.stamen.graphics.color.*;
	
	public class RGB extends Color implements IColor
	{
	    public var red:Number = 0;
	    public var green:Number = 0;
	    public var blue:Number = 0;
	
	    public static function black():RGB
	    {
	        return new RGB(0, 0, 0);
	    }
	
	    public static function white():RGB
	    {
	        return new RGB(255, 255, 255);
	    }
	
	    public static function grey(n:Number):RGB
	    {
	        return new RGB(n, n, n);
	    }
	
	    public static function random():RGB
	    {
	        return new RGB(Math.random() * 255,
	                       Math.random() * 255,
	                       Math.random() * 255);
	    }
	
	    public static function fromHex(hex:*):RGB
	    {
	        if (hex is String) hex = parseInt(hex, 16);
	        else hex = Number(hex);
	
	        var red:Number = (hex & 0xFF0000) >>> 16;
	        var green:Number = (hex & 0x00FF00) >>> 8; 
	        var blue:Number = hex & 0x0000FF;
	
	        return new RGB(red, green, blue);
	    }
	
	    public function RGB(r:Number=0, g:Number=0, b:Number=0)
	    {
	        red = r;
	        green = g;
	        blue = b;
	    }

	    public function copy():IColor
	    {
	        return new RGB(red, green, blue);
	    }
	
		public function equals(color:IColor):Boolean
		{
			return color && (color.toHex() == toHex() && alpha == color.alpha);
		}
	
	    public function toRGB():RGB
	    {
	        return copy() as RGB;
	    }
	
		public function invert():RGB
		{
			var hsv:HSV = toHSV();
			var inverted:HSV = hsv.invert();
			return inverted.toRGB();
		}
	
	    public function blend(color:IColor, amount:Number=0.5, asRGB:Boolean=false):IColor
	    {
	        if (asRGB)
	        {
	            var parts:Array = _blend(color.toRGB(), amount);
	            return new RGB(parts[0], parts[1], parts[2]);
	        }
	        else
	        {
	            return toHSV().blend(color.toHSV(), amount, false).toRGB();
	        }
	    }
	
	    public function toString():String
	    {
	        var parts:Array = toArray();
	        for (var i:int = 0; i < 3; i++)
	        {
	            parts[i] = zerofill(parts[i].toString(16), 2);
	        }
	        return parts.join('').toUpperCase();
	    }
	    
	    internal function zerofill(n:Number, len:int):String
	    {
	    	var nStr:String = n.toString();
	    	var nLen:int = nStr.length;
			while (nStr.length < len)
			{
				nStr = '0'.concat(nStr);
			}
			return nStr;
	    }
	    
	    public function toHSV():HSV
	    {
	        var r:Number = red / 255;
	        var g:Number = green / 255;
	        var b:Number = blue / 255;
	
	        var min:Number = Math.min(r, Math.min(g, b));
	        var max:Number = Math.max(r, Math.max(g, b));
	        var delta:Number = max - min;
	
	        var value:Number = max;
	        var hue:Number, sat:Number;
	
	        if (max == 0 || delta == 0)
	        {
	            hue = 0;
	            sat = 0;
	        }
	        else
	        {
	            sat = delta / max;
	
	            if      (r == max)  { hue = (g - b) / delta;     }
	            else if (g == max)  { hue = 2 + (b - r) / delta; }
	            else                { hue = 4 + (r - g) / delta; }
	
	            hue *= 60;
	            if (hue < 0) hue += 360;
	        }
	
			return new HSV(hue, sat, value);
	    }
	
	    public function toHex(withAlpha:Boolean=false):int
	    {
	    	var hex:int = (red << 16) | (green << 8) | blue;
			if (withAlpha)
	        {
	            hex >>= 8;
	            hex |= ((255 * alpha) << 24);
	        }
        	return hex;
	    }

		public function toRGBA(alpha:Number=1.0):RGBA
		{
			return RGBA.fromRGB(this, alpha);
		}

		public function toHSVA(alpha:Number=1.0):HSVA
		{
			return HSVA.fromHSV(toHSV(), alpha);
		}

	    override public function toArray():Array
	    {
	        return [red, green, blue];
	    }
	}
}