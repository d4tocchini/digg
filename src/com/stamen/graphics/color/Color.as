/*
 * vim:et sts=4 sw=4 cindent tw=120:
 * $Id: Color.as,v 1.1 2006/06/28 01:08:57 allens Exp $
 */

package com.stamen.graphics.color
{
    import com.stamen.graphics.color.IColor;

	/*
	 * This is not a public class. These methods are provided as a
	 * convenience for implemetations of IColor.
	 */
    internal class Color extends Object
    {
        protected function _blend(color:IColor, amount:Number):Array
        {
            var c1:Array = toArray();
            var c2:Array = color.toArray();
            var c3:Array = new Array();

            for (var i:Number = 0; i < c1.length; i++)
                c3[i] = c1[i] + (c2[i] - c1[i]) * amount;

            return c3;
        }

		public function get alpha():Number
		{
			return 1.0;
		}

		public function set alpha(alpha:Number):void
		{
		}

        public function toArray():Array
        {
        	return [];
        }
    }
}
