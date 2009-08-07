package com.digg.services.response
{
	import flash.xml.XMLNode;
	import com.digg.model.*;

	public class TopicsResponse extends Response
	{
		override protected function loadItems(node:XMLNode):uint
		{
			items = new Array();
			
			if (node.hasChildNodes())
			{
				for (var child:XMLNode = node.firstChild; child; child = child.nextSibling)
				{
					var topic:Topic = Topic.fromXML(child, model);
					items.push(topic);
				}
			}
			
			return items.length;
		}
	}
}