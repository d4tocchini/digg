package com.digg.model
{
	import com.digg.model.*;
	import flash.xml.XMLNode;
	import com.stamen.utils.DateUtils;
	
	public dynamic class Digg extends ModelObject
	{
		public var user:User;
		public var story:Story;
		public var date:Date;
		public var status:String;
		public var id:uint;
		public var storyStatus:String;
		
		public static function fromXML(node:XMLNode, model:Model):Digg
		{
			var digg:Digg = new Digg();
			digg.id = parseInt(node.attributes['id']);
			var user:User = new User(node.attributes['user']);
			digg.user = model
						? model.getUser(user, true)
						: user;
			var story:Story = new Story();
			story.id = parseInt(node.attributes['story']);
			digg.story = model
						 ? model.getStory(story, true)
						 : story;
			digg.storyStatus = node.attributes['status'];
			// promote the story
			if (digg.story.status == Story.UPCOMING && digg.storyStatus == Story.POPULAR)
			{
				digg.story.status = digg.storyStatus;
			}
			digg.date = DateUtils.fromTimestamp(node.attributes['date']);
			digg.loaded = true;
			return digg;
		}
		
		public function equals(digg:Digg):Boolean
		{
			return (user && user.equals(digg.user))
				   && (story && story.equals(digg.story));
		}
		
		override public function get key():String
		{
			return id.toString();
		}
		
		public function toString():String
		{
			return '[Digg by ' + user.toString() + ' on story ' + story.toString() + ' @ ' + date.toString() + ']';
		}
		
		public function get datetime():int 
		{
			return date ? date.time : 0;
		}
	}
}
