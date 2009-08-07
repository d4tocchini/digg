package com.stamen.utils
{
	import asunit.framework.Assert;
	
	public class NumberFormatter
	{
		public var decimalPlaces:uint;
		public var thousandsDelimiter:String = ',';
		public var decimalDelimiter:String = '.';

		public function NumberFormatter(decimalPlaces:uint=2)
		{
			this.decimalPlaces = decimalPlaces;
		}

		public function format(value:Number):String
		{
			var sign:String = (value >= 0) ? '' : '-';
			var out:String = value.toFixed(decimalPlaces);

			var exp:uint = Math.abs(value) >> 0;
			var man:uint = (decimalPlaces > 0) ? parseInt(out.split('.')[1]) : 0;
						
			var expString:String = exp.toString();
			var parts:Array = [];
			while (expString.length > 3)
			{
				var part:String = expString.substr(-3);
				parts.unshift(part);
				expString = expString.substr(0, expString.length - 3);
			}
			parts.unshift(expString);
			expString = parts.join(thousandsDelimiter);

			if (decimalPlaces > 0)
			{
				var manString:String = zerofill(man, 2);
				return [sign, expString, decimalDelimiter, manString].join('');
			}
			else
			{
				return sign + expString;
			}
		}

		public static function zerofill(value:*, len:int=2):String
		{
			var out:String = String(value);
			while (out.length < len) out = '0' + out;
			return out;
		}
	}
}