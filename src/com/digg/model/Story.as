package com.digg.model
{
	import com.stamen.utils.DateUtils;
	
	import flash.xml.XMLNode;

	public dynamic class Story extends ModelObject
	{
		public static const POPULAR:String = 'popular';
		public static const UPCOMING:String = 'upcoming';

		public var id:uint;
		public var title:String;
		public var href:String;
		public var link:String;
		public var diggs:uint;
        public var runtimeDiggs:int;
		public var comments:uint;
		public var description:String;
		public var submitter:User;
		public var status:String;
		public var submitDate:Date;
		public var promoteDate:Date;
		public var topic:Topic;
		public var container:Container;

		public var media:Media;
		
		public static function fromXML(node:XMLNode, model:Model=null):Story
		{
			var story:Story = new Story();
			story.id = parseInt(node.attributes['id']);
			if (model)
			{
				story = model.stories.getOrSet(story.key, story) as Story;
			}

            			
			for (var attr:String in node.attributes)
			{
			    var value:String = node.attributes[attr];
			    story.setAttribute(attr, value);
			}
			
			for (var child:XMLNode = node.firstChild; child; child = child.nextSibling)
			{
				switch (child.nodeName)
				{
					case 'title':
					case 'description':
						story.setAttribute(child.nodeName, child.firstChild ? child.firstChild.nodeValue : '');
						break;
						
					case 'user':
						story.submitter = User.fromXML(child, model);
						break;
					
					case 'topic':
						story.topic = Topic.fromXML(child, model);
						break;
					
					case 'container':
						story.container = Container.fromXML(child, model);
						break;
					
					case 'thumbnail':
					    story.media.applyXML(child);
					    break;
				}
			}
			
			if (story.topic && story.container)
			{
				if (!story.topic.container)
				{
					story.topic.container = story.container;
				}
			}
			
			story.loaded = true;
			return story;
		}
		
		public function Story(properties:Object=null)
		{
			super(properties);
		}

		override public function setAttribute(attr:String, value:*):void
		{
			switch (attr)
			{
				case 'id':
				case 'comments':
				case 'diggs':
					this[attr] = uint(value);
					break;

				case 'submit_date':				
					submitDate = DateUtils.fromTimestamp(value);
					break;
					
				case 'promote_date':
					promoteDate = DateUtils.fromTimestamp(value);
					break;
				
				case 'media':
				    media = new Media(value);
			        break;
			
				default:
					super.setAttribute(attr, value);
			}
		}

		override public function get key():String
		{
			return id.toString();
		}
		
		override public function get url():String
		{
			return href;
		}

        public function get domain():String
        {
            var i:int = link.indexOf('://'); 
            if (i > -1)
            {
                var out:String = link.substr(i + 3);
                i = out.indexOf('/');
                if (i > -1)
                {
                    return out.substr(0, i);
                }
                return out;
            }
            return link;
        }

		public function equals(story:Story):Boolean
		{
			return (story && id == story.id);
		}
		
		public function toString():String
		{
			return '[Story "' + title + '" (' + id + ')]';
		}
	}
}
