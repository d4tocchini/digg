/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

package com.stamen.graphics.color
{
	import com.stamen.graphics.color.*;

	public interface IColor
	{
	    function copy():IColor;
	    function equals(color:IColor):Boolean;
	
	    function toHex(withAlpha:Boolean=false):int;
	    function toArray():Array;
	    function toRGB():RGB;
	    function toRGBA(alpha:Number=1):RGBA;
	    function toHSV():HSV;
	    function toHSVA(alpha:Number=1):HSVA;

	    function blend(color:IColor, amount:Number=0.5, asRGB:Boolean=false):IColor;
	    
	    function get alpha():Number;
	    function set alpha(alpha:Number):void;
	}
}
