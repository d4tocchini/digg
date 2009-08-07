package com.digg.model
{
	import flash.xml.XMLNode;
	import com.stamen.utils.DateUtils;
	
	public dynamic class Comment extends ModelObject
	{
		public var user:User;
		public var story:Story;
		public var date:Date;
		public var text:String;

		public var id:uint;
		public var upDiggs:uint;
		public var downDiggs:uint;
		public var numReplies:uint;

		public static function fromXML(node:XMLNode, model:Model=null):Comment
		{
			var comment:Comment = new Comment(node.attributes);
			
			var user:User = new User(node.attributes['user']);
			comment.user = model
						   ? model.getUser(user, true)
						   : user;
			var story:Story = new Story();
			story.id = parseInt(node.attributes['story']);
			comment.story = model
							? model.getStory(story, true)
							: story;
			comment.text = node.firstChild.nodeValue;
			comment.loaded = true;
			return comment;
		}
		
		public function Comment(properties:Object=null)
		{
			super(properties);
		}
		
		override public function setAttribute(attr:String, value:*):void
		{
			switch (attr)
			{
				case 'id':
					id = uint(value);
					break;
					
				case 'up':
					upDiggs = uint(value);
					break;
					
				case 'down':
					downDiggs = uint(value);
					break;
					
				case 'replies':
					numReplies = uint(value);
					break;
					
				case 'date':
					date = DateUtils.fromTimestamp(value);
					break;
			}
		}
		
		override public function get key():String
		{
			return id.toString();
		}

		public function equals(comment:Comment):Boolean
		{
			return (comment && id == comment.id);
		}
		
		public function get datetime():int
		{
			return date ? date.time : 0;
		}
		
	}
}
