package com.digg.services.response
{
	import flash.xml.XMLNode;
	import com.digg.model.*;

	public class DiggsResponse extends Response
	{
		override protected function loadItems(node:XMLNode):uint
		{
			items = new Array();
			
			if (node.hasChildNodes())
			{
				for (var child:XMLNode = node.firstChild; child; child = child.nextSibling)
				{
					var digg:Digg = Digg.fromXML(child, model);
					items.push(digg);
				}
			}
			
			return items.length;
		}
	}
}