package com.stamen.utils
{
	import flash.utils.Dictionary;

	public dynamic class Hash extends Dictionary
	{
		public function Hash(weakKeys:Boolean=false)
		{
			super(weakKeys);
		}
		
		public function get length():uint
		{
			return getKeys().length;
		}

		public function getKeys():Array
		{
			var keys:Array = new Array();
			for (var key:String in this)
			{
				keys.push(key);
			}
			return keys;
		}
		
		public function getValues():Array
		{
			var values:Array = new Array();
			for (var key:String in this)
			{
				values.push(getKey(key));
			}
			return values;
		}

		public function hasKey(key:String):Boolean
		{
			return getKey(key) != null;
		}

		public function getKey(key:String):Object
		{
			return this[key];
		}
		
		public function setKey(key:String, value:Object):void
		{
			this[key] = value;
		}
		
		public function removeKey(key:String):Boolean
		{
			try
			{
				delete this[key];
			}
			catch (e:Error)
			{
				return false;
			}
			return true;
		}
		
		public function getOrSet(key:String, value:Object):Object
		{
			if (!hasKey(key))
			{
				setKey(key, value);
			}
			return getKey(key);
		}
	}
}