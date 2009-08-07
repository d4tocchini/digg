/*
	This was last pulled from 
		code.google.com/p/diggflashdevkit/
	on 7/31/09
	
	
	Caching API Responses
		Most applications don't need real-time API responses and so should use caching to avoid getting blocked. 
		This is especially true if you have a high-traffic web site and you want to display Digg data directly on your web pages. 
		-Real-time API responses are fine when requesting multiple stories, users' diggs, etc.
		-Cached Responses are for the widgets that display the number of diggs of a particular post on the website?...
	
		real-time API responses:	http://services.digg.com/
		
			http://services.digg.com/stories/popular
			http://services.digg.com/stories/?link=http://stylizedweb.com/2008/02/14/10-best-css-hacks/&appkey=http%3A%2F%2Fexample.com%2Fapplication&type=xml
		
		public api proxy (cached responses): http://services.digg.com/
			
			http://digg.com/tools/services?endPoint=/stories/popular&type=xml
			
			http://digg.com/tools/services?endPoint=%2Fstories&link=http%3A%2F%2Fblog.digg.com%2F%3Fp%3D98&type=xml&appkey=http%3A%2F%2Fexample.com
			http://digg.com/tools/services?endPoint=/stories&link=http://blog.digg.com/?p=98&type=xml&appkey=http://example.com
			
			for more info: http://apidoc.digg.com/BasicConcepts#UserAgents
*/
package com.digg.services
{
	import com.digg.model.*;
	import com.digg.services.response.*;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public class API
	{
		public static var DEBUG:Boolean = false;
		
		public static var errorDispatcher:EventDispatcher = new EventDispatcher();
		
		public static var baseProxyURL:String = 'http://digg.com/tools/services?endPoint=/';
		public static var baseURL:String = 'http://services.digg.com/';
		public static var appKey:String;
		public static var model:Model;
		
        /**
         * You can set these globally if you're only interested certain media types.
         * - mediaType takes one of the Media constants: Media.IMAGE, Media.VIDEO, or Media.NEWS.
         * - mediaSize takes one of the MediaSize constants. This determines the
         *   size of the thumbnails returned inside <story/> elements, which are converted into
         *   Media instances in Story.fromXML().
         */
		public static var mediaType:String;
		public static var mediaSize:String;
		
		
		/**
         * Taken from computus.org on 7/31/09... unteseted
         */
		public static function searchStories( query: String ):StoriesResponse
		{
		   var request:URLRequest = new URLRequest(getURL('search/stories'));
		   var args:URLVariables = new URLVariables()
		   args['query'] = query
		   if (mediaSize)
		   {
		      if (!args['size']) args['size'] = mediaSize;
		   }
		   request.data = args;
		   return load(request, new StoriesResponse()) as StoriesResponse;
		}

		public static function getURL(path:String):String
		{
			if (baseURL.substr(-1) == '/' && path.charAt(0) == '/')
			{
				path = path.substr(1);
			}
			return baseURL.concat(path);
		}
		
		public static function getProxyURL(path:String):String
		{
			if (baseURL.substr(-1) == '/' && path.charAt(0) == '/')
			{
				path = path.substr(1);
			}
			return baseURL.concat(path);
		}
		
		

		public static function load(request:URLRequest, response:IResponse=null, captureErrors:Boolean=true):IResponse
		{
			if (appKey)
			{
				if (!request.data) request.data = new URLVariables();
				request.data.appkey = appKey;
			}

			if (!response)
			{
				response = new Response();
			}

			if (captureErrors)
			{
				response.addEventListener(ErrorEvent.ERROR, onResponseError);
				response.addEventListener(Event.COMPLETE, onResponseComplete);
			}
			if (DEBUG)
			{
				trace("API.load() loading: " + request.url + (request.data ? '?' + request.data.toString() : ''));
			}
			
			if (model)
			{
				response.useModel(model);
			}
			response.load(request);
			return response;
		}

		public static function getUserURL(user:*):String
		{
			if (!(user is User) && !(user is String))
			{
				throw new Error('getUserURL() expects a User instance or username string; got: ' + user);
			}
			return getURL('user/'.concat((user is User) ? user.name : user));
		}

		public static function getStoryURL(story:*):String
		{
			if (!(story is Story) && !(story is String) && !(story is Number))
			{
				throw new Error('getStoryURL() expects a Story instance or story id; got: ' + story);
			}
			var storyID:int = (story is Story)
							  ? (story as Story).id
							  : int(story);
			return getURL('story/'.concat(storyID));
		}
		
		public static function getStoriesURL(status:String=null, useProxy:Boolean=false):String
		{
			var path:String = 'stories';
			if (status) path = path.concat('/', status);
			if(useProxy) return getProxyURL(path);
			return getURL(path);
		}

		/**
		 * Get the URL for a container. Accepts either a Container instance or a container's short name variant.
		 * See: http://apidoc.digg.com/Topics for a list of available containers.
		 */
		public static function getContainerURL(container:*):String
		{
			if (!(container is Container) && !(container is String))
			{
				throw new Error('getContainerURL() expects a Container instance or short name string; got: ' + container);
			}
			var containerName:String = (container is Container)
									   ? (container as Container).shortName
									   : String(container);
			return getURL('stories/container/' + containerName);
		}

		/**
		 * Get the URL for a topic. Accepts either a Topic instance or a topic's short name variant.
		 * See: http://apidoc.digg.com/Topics for a list of available topics.
		 */
		public static function getTopicURL(topic:*):String
		{
			if (!(topic is Topic) && !(topic is String))
			{
				throw new Error('getTopicURL() expects a Topic instance or short name string; got: ' + topic);
			}
			var topicName:String = (topic is Topic)
								   ? (topic as Topic).shortName
								   : String(topic);
			return getURL('stories/topic/' + topicName);
		}

		/**
		 * Get the URL for an arbitrary scope. Valid scopes include:
		 * 
		 * - an individual story (see getStoryURL())
		 * - a topic or container (see getTopicURL() and getContainerURL())
		 * 
		 * If none of the above is provided, we fall back getStoriesURL().
		 */
		public static function getScopeURL(scope:*=null):String
		{
			if (scope is Story || scope is Number)
			{
				return getStoryURL(scope);
			}
			else if (scope is Container)
			{
				return getContainerURL(scope as Container);
			}
			else if (scope is Topic)
			{
				return getTopicURL(scope as Topic);
			}
			else if (scope is User)
			{
				return getUserURL(scope as User);
			}

			return getStoriesURL(scope as String);
		}

        public static function getMediaURL():String
        {
            return getURL('media');
        }

		/**
		 * Get the URL representing a list of diggs specific to a given scope.
		 * See getScopeURL() for a list of valid arguments.
		 */
		public static function getDiggsURL(scope:*=null):String
		{
			return getScopeURL(scope).concat('/diggs');
		}
		
		/**
		 * Get the URL representing a list of comments specific to a given scope.
		 * See getScopeURL() for a list of valid arguments.
		 */
		public static function getCommentsURL(scope:*=null):String
		{
			return getScopeURL(scope).concat('/comments');
		}
		
		/**
		 * Get a list of diggs in the given scope. See getScopeURL() for more info.
		 */
		public static function getDiggs(scope:*=null, args:URLVariables=null):DiggsResponse
		{
			var request:URLRequest = new URLRequest(getDiggsURL(scope));
			if (mediaType)
			{
			    if (!args) args = new URLVariables();
			    if (!args['media']) args['media'] = mediaType;
			}
			request.data = args;
			return load(request, new DiggsResponse()) as DiggsResponse;
		}

		/**
		 * Get a list of comments in the given scope. See getScopeURL() for more info.
		 */
		public static function getComments(scope:*=null, args:URLVariables=null):CommentsResponse
		{
			var request:URLRequest = new URLRequest(getCommentsURL(scope));
			request.data = args;
			return load(request, new CommentsResponse()) as CommentsResponse;
		}
		
		/**
		 * Get more information for a story given an ID.
		 */
		public static function getStoryFromID(story:*, args:URLVariables=null):StoriesResponse
		{
			var request:URLRequest = new URLRequest(getStoryURL(story));
			if (mediaSize)
			{
			    if (!args) args = new URLVariables();
			    if (!args['size']) args['size'] = mediaSize;
			}
			request.data = args;
			return load(request, new StoriesResponse()) as StoriesResponse;
		}
		
		public static function getStoryFromLink(link:String, args:URLVariables=null):StoriesResponse
		{
			var request:URLRequest = new URLRequest(getStoriesURL(null,true));
			if (!args) args = new URLVariables();
			args['link'] = link;
			if (mediaSize)
			{
			    if (!args['size']) args['size'] = mediaSize;
			}
			request.data = args;
			return load(request, new StoriesResponse()) as StoriesResponse;
		}
		
		
		
		/**
		 * Get a list of stories. The optional status argument should be one of the Story
		 * constants: Story.UPCOMING or Story.POPULAR.
		 */
		public static function getStories(scope:*=null, args:URLVariables=null):StoriesResponse
		{
			var request:URLRequest = new URLRequest(getScopeURL(scope));
			if (mediaSize)
			{
			    if (!args) args = new URLVariables();
			    if (!args['size']) args['size'] = mediaSize;
			}
			request.data = args;
			return load(request, new StoriesResponse()) as StoriesResponse;
		}
		
		/**
		 * Get a list of stories of a certain media type. Acceptable values for the type argument are:
		 * 1) a valid media "short name": "images", "videos", "news", or "all"
		 * 2) an Array of valid media short names.
		 */
		public static function getMedia(type:*=null, scope:*=null, args:URLVariables=null):StoriesResponse
		{
		    if (!args) args = new URLVariables();
		    if (type is Array)
		    {
		        args['media'] = (type as Array).join(',');
		    }
		    else if (type is String)
		    {
		        args['media'] = type;
		    }

		    return getStories(scope, args);
		}

		/**
		 * Get more information pertaining to stories in a list of diggs.
		 */
		public static function getStoriesFromDiggs(diggs:Array, args:URLVariables=null):StoriesResponse
		{
		    if (diggs.length == 0) return null;
			var getStoryID:Function = function(digg:Digg, index:uint, arr:Array):uint
			{
				return digg.story.id;
			};
			var ids:Array = diggs.map(getStoryID);
			ids.sort(Array.NUMERIC | Array.UNIQUESORT);
			if (null == args)
			{
				args = new URLVariables();
			}
			if (ids.length > 0)
			{
    			args['count'] = ids.length;
    			return getStoriesByID(ids, args);
            }
            else
            {
                return null;
            }
		}

		/**
		 * Get a list of stories by ID.
		 */
		public static function getStoriesByID(ids:Array, args:URLVariables=null):StoriesResponse
		{
			var url:String = getURL('stories/'.concat(ids.join(',')));
			var request:URLRequest = new URLRequest(url);
			if (mediaSize)
			{
			    if (!args) args = new URLVariables();
			    if (!args['size']) args['size'] = mediaSize;
			}
			if (args) request.data = args;
			return load(request, new StoriesResponse()) as StoriesResponse;
		}

		/**
		 * Load a user's profile from the API.
		 */
		public static function getUser(user:*):UserResponse
		{
			var request:URLRequest = new URLRequest(getUserURL(user));
			return load(request, new UserResponse()) as UserResponse;
		}
		
		/**
		 * Get a list of the user's diggs.
		 */
		public static function getUserDiggs(user:*, args:URLVariables=null):DiggsResponse
		{
			var request:URLRequest = new URLRequest(getUserURL(user).concat('/diggs'));
			request.data = args;
			return load(request, new DiggsResponse()) as DiggsResponse;
		}

		public static function getContainers(args:URLVariables=null):ContainersResponse
		{
			var request:URLRequest = new URLRequest(getURL('containers'));
			request.data = args;
			return load(request, new ContainersResponse()) as ContainersResponse;
		}

		public static function getTopics(args:URLVariables=null):TopicsResponse
		{
			var request:URLRequest = new URLRequest(getURL('topics'));
			request.data = args;
			return load(request, new TopicsResponse()) as TopicsResponse;
		}

		/**
		 * Determine whether or not a user dugg a particular story.
		 * The DiggsResponse that comes back should have exactly one Digg in its
		 * items array.
		 */
		public static function getUserStoryDigg(user:User, story:Story, args:URLVariables=null):DiggsResponse
		{
			var path:String = ['story', story.id, 'user', user.name, 'digg'].join('/');
			var request:URLRequest = new URLRequest(getURL(path));
			request.data = args;
			return load(request, new DiggsResponse()) as DiggsResponse;
		}

		/**
		 * Get a list of a users' friends.
		 */
		public static function getUserFriends(user:*):UsersResponse
		{
			var request:URLRequest = new URLRequest(getUserURL(user).concat('/friends'));
			return load(request, new UsersResponse()) as UsersResponse;
		}
		
		/**
		 * This is an error handler for response errors.
		 */
		protected static function onResponseError(event:ErrorEvent):void
		{
			if (DEBUG) trace('caught response error (type "' + event.type + '"): "' + event.text + '"');
			removeEventListeners(event.target as IResponse);
			errorDispatcher.dispatchEvent(event);
		}
		
		protected static function onResponseComplete(event:Event):void
		{
			var response:IResponse = event.target as IResponse;
			if (DEBUG) trace('response complete: ' + response.getURL());
			removeEventListeners(response);
		}
		
		protected static function removeEventListeners(response:IResponse):void
		{
			response.removeEventListener(ErrorEvent.ERROR, onResponseError);
			response.removeEventListener(Event.COMPLETE, onResponseComplete);
		}
	}
}
