package com.stamen.utils
{
	public class DateUtils
	{
		public static const SECOND:uint = 1000;
		public static const MINUTE:uint = SECOND * 60;
		public static const HOUR:uint = MINUTE * 60;
		public static const DAY:uint = HOUR * 24;
		public static const WEEK:uint = DAY * 7;
		
		public static function fromString(str:String):Date
		{
			var year:uint = parseInt(str.substring(0, 4));
			var month:uint = parseInt(str.substring(5, 7)) - 1;
			var day:uint = parseInt(str.substring(8, 10));
			return new Date(year, month, day, 0, 0, 0, 0);
		}

		public static function makeDateString(date:Date):String
		{
			return date.fullYear.toString() + NumberFormatter.zerofill(date.month + 1) + NumberFormatter.zerofill(date.date);
		}

		public static function format(date:Date, relative:Boolean=true, withTime:Boolean=false):String
		{
		    var now:Date = new Date();
		    if (relative && date.toDateString() == now.toDateString())
		    {
		        return 'today';
		    }
			var out:String = (date.month + 1) + '/' + date.date + '/' + date.fullYear.toString().substr(2);
			if (withTime)
			{
				out += ' ' + date.toTimeString().substr(0, 5);
			}
			return out;
		}

		public static function fromTimestamp(timestamp:*):Date
		{
			return new Date(Number(timestamp) * SECOND);
		}

		public static function toTimestamp(date:Date):uint
		{
			return (date.time / SECOND) >> 0;
		}
		
		public static function copy(date:Date):Date
		{
			return date ? fromTimestamp(toTimestamp(date)) : null;
		}
		
		public static function compare(a:Date, b:Date):Boolean
		{
			return (a && b) || (!a && !b) || (a.time == b.time);
		}
		
		public static function add(date:Date, offset:Object):Date
		{
			var out:Date = copy(date);
			for (var part:String in offset)
			{
				var off:int = int(offset[part]);
				switch (part.toLowerCase())
				{
					case 'year':
					case 'years':
						out.fullYear += off;
						break;
					case 'month':
					case 'months':
						out.month += off;
						break;
					case 'day':
					case 'days':
						out.date += off;
						break;
					case 'hour':
					case 'hours':
						out.hours += off;
						break;
					case 'minute':
					case 'minutes':
						out.minutes += off;
						break;
					case 'second':
					case 'seconds':
						out.seconds += off;
						break;
					case 'week':
					case 'weeks':
						out.time += WEEK * off;
						break;
				}
			}
			return out;
		}
	}
}