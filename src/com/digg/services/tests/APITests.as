package com.digg.services.tests
{
	import asunit.framework.TestCase;
	
	import com.digg.model.*;
	import com.digg.services.API;
	
	public class APITests extends TestCase
	{
		public function testURLs1():void
		{
			assertEquals('http://services.digg.com/stories', API.getStoriesURL());
			assertEquals('http://services.digg.com/stories/popular', API.getStoriesURL(Story.POPULAR));
			assertEquals('http://services.digg.com/stories/upcoming', API.getStoriesURL(Story.UPCOMING));

			assertEquals('http://services.digg.com/story/123', API.getStoryURL(123));
			var story:Story = new Story();
			story.id = 456;
			assertEquals('http://services.digg.com/story/456', API.getStoryURL(story));
			assertEquals('http://services.digg.com/story/456/diggs', API.getDiggsURL(story));
			assertEquals('http://services.digg.com/story/456/comments', API.getCommentsURL(story));
			
			var topic:Topic = new Topic();
			topic.shortName = 'offbeat_news';
			assertEquals('http://services.digg.com/stories/topic/offbeat_news', API.getTopicURL(topic));

			var container:Container = new Container();
			container.shortName = 'videos';
			assertEquals('http://services.digg.com/stories/container/videos', API.getContainerURL(container));
			
			assertEquals('http://services.digg.com/user/shawnbot', API.getUserURL('shawnbot'));
			var user:User = new User('migurski');
			assertEquals('http://services.digg.com/user/migurski', API.getUserURL(user));
		}
	}
}