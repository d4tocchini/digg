package com.digg.services.response
{
	import flash.xml.XMLNode;
	import com.digg.model.Comment;
	
	public class CommentsResponse extends Response
	{
		override protected function loadItems(node:XMLNode):uint
		{
			items = new Array();
			
			if (node.hasChildNodes())
			{
				for (var child:XMLNode = node.firstChild; child; child = child.nextSibling)
				{
					var comment:Comment = Comment.fromXML(child, model);
					items.push(comment);
				}
			}

			return items.length;
		}
	}
}