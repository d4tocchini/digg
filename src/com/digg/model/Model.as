package com.digg.model
{
	import com.stamen.utils.Hash;
	
	public class Model
	{
		public var users:Hash;
		public var stories:Hash;
		public var topics:Hash;
		public var containers:Hash;
		public var diggs:Array;
		public var comments:Array;
		
		protected static var _singleton:Model;
		
		public static function get singleton():Model
		{
			if (!_singleton) _singleton = new Model();
			return _singleton;
		}

		public function Model()
		{
			flush();
		}

		/**
		 * Empty the model. Be sure to clean up your references to
		 * objects you got from the model, otherwise the garbage
		 * collector won't be able to remove them from memory.
		 */
		public function flush():void
		{
			users = new Hash(true);
			stories = new Hash(true);
			topics = new Hash(true);
			containers = new Hash(true);

			diggs = new Array();
			comments = new Array();
		}

		/**
		 * For backwards compatibility.
		 */
		public var empty:Function = flush;

		/**
		 * Get a user from the model. The supplied user need only have
		 * a username in order to obtain a reference to the (hopefully)
		 * more descriptive object.
		 * 
		 * Set <tt>setIfNotFound</tt> to true if you wish to populate the 
		 * model with the supplied user in the event that one with the
		 * provided username doesn't already exist.
		 */
		public function getUser(user:User, setIfNotFound:Boolean=false):User
		{
			return (setIfNotFound
				    ? users.getOrSet(user.key, user)
				    : users.getKey(user.key)) as User;
		}

		/**
		 * Determine if a user has already been added.
		 */
		public function hasUser(user:User):Boolean
		{
			return (users.getKey(user.key) as User) != null;
		}

		/**
		 * Add a user to the model. This will return false if a user
		 * with the same name already exists.
		 */
		public function addUser(user:User):Boolean
		{
			if (hasUser(user))
			{
				return false;
			}
			else
			{
				users.setKey(user.key, user);
				return true;
			}
		}
		
		/**
		 * Remove a user from the model.
		 */
		public function removeUser(user:User):Boolean
		{
			return users.removeKey(user.key);
		}
		
		/**
		 * Get a story from the model. The provided story object need
		 * only have the id filled to get a reference to the (hopefully)
		 * more descriptive story.
		 * 
		 * Set <tt>setIfNotFound</tt> to true if you want to put the
		 * provided story into the model in the event that it doesn't
		 * exist already.
		 */
		public function getStory(story:Story, setIfNotFound:Boolean=false):Story
		{
			return (setIfNotFound
				    ? stories.getOrSet(story.key, story)
				    : stories.getKey(story.key)) as Story;
		}
		
		/**
		 * Determine if the story has already been added.
		 */
		public function hasStory(story:Story):Boolean
		{
			return (stories.getKey(story.key) as Story) != null;
		}

		/**
		 * Add a story to the model. This will return false if a story
		 * with the same id already exists.
		 */
		public function addStory(story:Story):Boolean
		{
			if (hasStory(story))
			{
				return false;
			}
			else
			{
				stories.setKey(story.key, story);
				return true;
			}
		}
		
		/**
		 * Remove a story from the model.
		 */
		public function removeStory(story:Story):Boolean
		{
		    var removed:Boolean = users.removeKey(story.key);
		    for (var i:int = diggs.length - 1; i >= 0; i--)
		    {
		        if ((diggs[i] as Digg).story.equals(story))
		        {
		            diggs.splice(i, 1);
		            i++;
		        }
		    }
			return removed; 
		}
		
		/**
		 * Determine if a digg has already been registered.
		 */
		public function hasDigg(digg:Digg):Boolean
		{
			if (diggs.length == 0) return false;

			for (var i:int = diggs.length - 1; i >= 0; i--)
			{
				if ((diggs[i] as Digg).equals(digg))
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * Add a digg to the model, and return the number of total
		 * existing diggs.
		 */
		public function addDigg(digg:Digg, strict:Boolean=false):uint
		{
			if (strict && hasDigg(digg))
			{
				throw new Error('Found dupe digg: ' + digg);
			}
			return diggs.push(digg);
		}
		
		/**
		 * Remove a digg from the model. This returns false if the
		 * digg doesn't exist.
		 */
		public function removeDigg(digg:Digg):Boolean
		{
			var index:uint = diggs.indexOf(digg);
			if (index > -1)
			{
				diggs.splice(index, 1);
				return true;
			}
			else
			{
				return false;
			}
		}

		/**
		 * Determine if a comment has already been added.
		 */		
		public function hasComment(comment:Comment):Boolean
		{
			if (comments.length == 0) return false;
			
			for (var i:uint = comments.length - 1; i >= 0; i--)
			{
				if ((comments[i] as Comment).equals(comment))
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * Add a comment to the model, and return the number of total
		 * existing comments.
		 */
		public function addComment(comment:Comment, strict:Boolean=false):uint
		{
			if (strict && hasComment(comment))
			{
				throw new Error('Found dupe comment: ' + comment);
			}
			return comments.push(comment);
		}
		
		/**
		 * Remove a comment from the model. This returns false if the
		 * comment doesn't exist.
		 */
		public function removeComment(comment:Comment):Boolean
		{
			var index:uint = comments.indexOf(comment);
			if (index > -1)
			{
				diggs.splice(index, 1);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * Get diggs by a given user.
		 */
		public function getUserDiggs(user:User):Array
		{
			var filter:Function = function(digg:Digg, ...rest):Boolean
			{
				return digg.user.equals(user);
			};
			return diggs.filter(filter);
		}
		
		/**
		 * Get comments by a given user.
		 */
		public function getUserComments(user:User):Array
		{
			var filter:Function = function(comment:Comment, ...rest):Boolean
			{
				return comment.user.equals(user);
			};
			return comments.filter(filter);
		}
		
		/**
		 * Get diggs from the model made on a given story.
		 */
		public function getStoryDiggs(story:Story):Array
		{
			var filter:Function = function(digg:Digg, ...rest):Boolean
			{
				return digg.story.equals(story);
			};
			return diggs.filter(filter);
		}

		/**
		 * Get comments from the model made on a given story.
		 */
		public function getStoryComments(story:Story):Array
		{
			var filter:Function = function(comment:Comment, ...rest):Boolean
			{
				return comment.story.equals(story);
			};
			return comments.filter(filter);
		}
		
		/**
		 * Get topics in a given container.
		 */
		public function getContainerTopics(container:Container):Array
		{
			var filter:Function = function(topic:Topic, ...rest):Boolean
			{
				return topic.container.equals(container);
			};
			return topics.getValues().filter(filter);
		}

		/**
		 * Get stories in a given topic.
		 */		
		public function getTopicStories(topic:Topic):Array
		{
			var filter:Function = function(story:Story, ...rest):Boolean
			{
				return story.topic.equals(topic);
			};
			return stories.getValues().filter(filter);
		}
		
		/**
		 * Get stories in a given container.
		 */
		public function getContainerStories(container:Container):Array
		{
			var filter:Function = function(story:Story, ...rest):Boolean
			{
				return story.container.equals(container);
			};
			return stories.getValues().filter(filter);
		}
	}
}