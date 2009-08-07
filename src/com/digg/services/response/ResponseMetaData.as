package com.digg.services.response
{
	import com.stamen.utils.DateUtils;
	
	import flash.xml.XMLNode;

	/*
	 * The ResponseMetaData class encapsulates information about the response data.
	 */
	public dynamic class ResponseMetaData extends Object
	{
		public var date:Date;
		public var count:uint;
		public var total:uint;
		public var offset:uint;
		public var min_date:Date;
		public var max_date:Date;
		public var timestamp:Date; // the min_date you requested may be rounded for caching efficiency

		public static function fromXML(node:XMLNode):ResponseMetaData
		{
			var meta:ResponseMetaData = new ResponseMetaData();
			if (!node) return meta;

			meta.date = DateUtils.fromTimestamp(node.attributes['timestamp']);

			for each (var intParam:String in ['count', 'total', 'offset'])
			{
				if (node.attributes[intParam] != null)
				{
					meta[intParam] = parseInt(node.attributes[intParam]);
				}
			}

			for each (var dateParam:String in ['min_date', 'max_date', 'timestamp'])
			{
				if (node.attributes[dateParam] != null)
				{
					meta[dateParam] = DateUtils.fromTimestamp(node.attributes[dateParam]);
				}
			}
			return meta;
		}	
	}
}