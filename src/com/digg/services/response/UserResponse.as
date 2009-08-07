package com.digg.services.response
{
	import flash.xml.XMLNode;
	import com.digg.model.User;

	public class UserResponse extends Response
	{
		override protected function loadItems(node:XMLNode):uint
		{
			items = new Array();

			var user:User = User.fromXML(node.firstChild, model);
			items.push(user);
			
			return items.length;
		}

	}
}