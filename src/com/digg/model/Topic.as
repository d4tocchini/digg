package com.digg.model
{
	import flash.xml.XMLNode;
	
	public dynamic class Topic extends ModelObject
	{
		public var shortName:String;
		public var container:Container;

		public static function fromXML(node:XMLNode, model:Model=null):Topic
		{
			var topic:Topic = new Topic(node.attributes);
			if (model)
			{
				topic = model.topics.getOrSet(topic.key, topic) as Topic;
			}
			if (node.hasChildNodes())
			{
				topic.container = Container.fromXML(node.firstChild, model);
				topic.container.topics.push(topic);
			}
			
			topic.loaded = true;
			return topic;
		}
		
		public function Topic(properties:Object=null)
		{
			super(properties);
		}
		
		override public function setAttribute(attr:String, value:*):void
		{
			switch (attr)
			{
				case 'short_name':
					shortName = value as String;
					break;
					
				default:
					super.setAttribute(attr, value);
			}
		}
		
		public function equals(topic:Topic):Boolean
		{
			if (!topic) return false;
			var containerValid:Boolean = topic.container
										 ? topic.container.equals(container)
										 : false;
			return (containerValid && shortName == topic.shortName);
		}
		
		public function toString():String
		{
			return name;
		}

		override public function get key():String
		{
			return shortName;
		}
		
		override public function get url():String
		{
			return 'http://digg.com/' + shortName;
		}
	}
}