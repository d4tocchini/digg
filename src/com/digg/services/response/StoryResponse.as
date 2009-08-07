package com.digg.services.response
{
	import com.digg.model.Story;
	
	import flash.xml.*;
	
	public class StoryResponse extends Response
	{
		override protected function loadItems(node:XMLNode):uint
		{
			items = new Array();

			var story:Story = Story.fromXML(node.firstChild, model);
			items.push(story);
			
			return items.length;
		}
	}
}