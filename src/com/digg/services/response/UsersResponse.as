package com.digg.services.response
{
	import flash.xml.XMLNode;
	import com.digg.model.User;

	public class UsersResponse extends Response
	{
		override protected function loadItems(node:XMLNode):uint
		{
			items = new Array();
			
			if (node.hasChildNodes())
			{
				for (var child:XMLNode = node.firstChild; child; child = child.nextSibling)
				{
					var user:User = User.fromXML(child, model);
					items.push(user);
				}
			}
			
			return items.length;
		}

	}
}