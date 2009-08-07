package com.digg.model
{
	import flash.xml.XMLNode;

	public dynamic class User extends ModelObject
	{
		public static const ICON_WIDTH:int = 48;
		public static const ICON_HEIGHT:int = ICON_WIDTH;

		// URL of their icon
		public var icon:String;
		public var registered:Date;
		public var profileViews:uint;
		
		public static function fromXML(node:XMLNode, model:Model=null, nameAttr:String='name'):User
		{
			var user:User = new User(node.attributes[nameAttr]);
			if (model)
			{
				user = model.users.getOrSet(user.name, user) as User;
			}
			if (node.attributes['icon'])
				user.icon = node.attributes['icon'];
			if (node.attributes['registered'])
				user.registered = new Date(uint(node.attributes['registered']) * 1000);
			if (node.attributes['profileviews'])
				user.profileViews = uint(node.attributes['profileviews']);

			user.loaded = user.icon ? true : false;
			return user;
		}

		public function User(username:String)
		{
			name = username;
		}

		override public function get url():String
		{
			return 'http://digg.com/users/'.concat(name, '/profile');
		}

		public function equals(user:User):Boolean
		{
			return (user && user.name == name);
		}

        public function getIconURL(size:String):String
        {
            return 'http://digg.com/users/'.concat(name, '/', size, '.png');
        }

		public function toString():String
		{
			return '[User "' + name + '"]';
		}
	}
}
