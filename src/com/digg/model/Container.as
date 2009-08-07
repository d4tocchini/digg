package com.digg.model
{
	import flash.xml.XMLNode;
	
	public dynamic class Container extends Topic
	{
		public var topics:Array;
		
		public function Container(properties:Object=null)
		{
			super(properties);
			topics = new Array();
		}

		public static function fromXML(node:XMLNode, model:Model=null):Container
		{
			var container:Container = new Container(node.attributes);
			if (model)
			{
				container = model.containers.getOrSet(container.key, container) as Container;
			}
			if (node.hasChildNodes())
			{
			    for (var topicNode:XMLNode = node.firstChild; topicNode; topicNode = topicNode.nextSibling)
			    {
			        var topic:Topic = Topic.fromXML(topicNode);
			        container.topics.push(topic);
			    }
			}
			container.loaded = true;
			return container;
		}

		override public function get key():String
		{
			return shortName;
		}

		override public function equals(topic:Topic):Boolean
		{
			var container:Container = topic as Container;
			return (container && shortName == container.shortName);
		}

		override public function get url():String
		{
			return 'http://digg.com/view/' + shortName;
		}
	}
}