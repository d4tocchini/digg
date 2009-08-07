package com.stamen.utils
{
	public class MathUtils
	{
	    public static function random(min:Number, max:Number, round:Boolean):Number
	    {
	        var n:Number = min + Math.random() * (max - min);
	        return round ? Math.round(n) : n;
	    }

	    public static function bound(value:Number, min:Number, max:Number):Number
	    {
	        if (!isFinite(value)) value = 0;
	        return Math.min(max, Math.max(min, value));
	    }

	    public static function scaleMinMax(value:Number, min:Number, max:Number, bound:Boolean=true):Number
	    {
	        if (bound)
	            value = MathUtils.bound(value, min, max);
	        return (value - min) / (max - min);
	    }

	    public static function logn(x:Number, base:Number):Number
	    {
	        if (!base) base = Math.E;
	        return Math.log(x) / Math.log(base);
	    }

		public static function degrees(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
		
		public static function radians(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}

		public static function normalizeRadians(radians:Number):Number
		{
			radians %= Math.PI * 2;
			return (radians < 0)
				   ? radians + Math.PI * 2
				   : radians;
		}
		
		public static function cubicBezier(t:Number, b:Number, c:Number,
										   d:Number, p1:Number, p2:Number):Number
	    {   
    	    return ((t /= d) * t * c +
				   3 * (1 - t) * (t * (p2 - b) +
				   (1 - t) * (p1 - b))) * t + b;
		}
	}
}
