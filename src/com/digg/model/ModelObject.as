package com.digg.model
{
	import flash.xml.XMLNode;
	
	public dynamic class ModelObject extends Object
	{
		public var name:String;
		public var loaded:Boolean = false;
		
		public function ModelObject(properties:Object=null)
		{
			if (properties)
			{
				for (var attr:String in properties)
				{
					setAttribute(attr, properties[attr]);
				}
			}
		}

		public function get key():String
		{
			return safeKey();
		}
		
		protected function safeKey(key:String=null, prefix:String=null):String
		{
			if (!key) key = name;
			return prefix ? prefix.concat(key) : key;
		}
		
		public function setAttribute(attr:String, value:*):void
		{
		    try
		    {
                this[attr] = value;
            }
            catch (e:Error)
            {
                trace("Unable to set property '" + attr + "': " + e.message);
            }
		}
		
		public function get url():String
		{
			return null;
		}
		
		public function update(obj:ModelObject):Boolean
		{
			var updated:Boolean = false;
			for (var attr:String in obj)
			{
				if (hasOwnProperty(attr) && (typeof obj[attr] == typeof this[attr]) && (obj[attr] != this[attr]))
				{
					setAttribute(attr, obj[attr]);
					updated = true;
				}
			}
			return updated;
		}
		
		public function getLink(text:String, href:String, target:String):String
		{
			if (!text) text = name;
			if (!href) href = url;
			if (!target) target = '_blank';
			return '<a href="' + escape(href) + '" target="' + target + '">' + text + '</a>';
		}
	}
}