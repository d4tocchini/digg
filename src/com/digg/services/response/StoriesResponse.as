package com.digg.services.response
{
	import flash.xml.XMLNode;
	import com.digg.model.*;

	public class StoriesResponse extends com.digg.services.response.Response
	{
		override protected function loadItems(node:XMLNode):uint
		{
			items = new Array();

			if (node.hasChildNodes())
			{
				for (var child:XMLNode = node.firstChild; child; child = child.nextSibling)
				{
					var story:Story = Story.fromXML(child, model);
					items.push(story);
				}
			}

			return items.length;
		}
	}
}