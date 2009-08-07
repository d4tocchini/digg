package com.digg.model
{
    import flash.xml.XMLNode;
    
	public dynamic class Media extends ModelObject
	{
	    public static const ALL:String = 'all';
	    public static const NEWS:String = 'news';
		public static const VIDEO:String = 'videos';
		public static const IMAGE:String = 'images';
		
		public var type:String;
		public var contentType:String;
		public var src:String;
		public var width:uint;
		public var height:uint;
		public var originalWidth:uint;
		public var originalHeight:uint;
		
		public function Media(type:String=null, src:String='', width:uint=0, height:uint=0)
		{
			super();
			this.type = type;
			this.src = src;
			this.width = width;
			this.height = height;
		}
		
		override public function get url():String
		{
			return src;
		}
		
		public function applyXML(node:XMLNode):void
		{
		    contentType = node.attributes['contentType'];
		    src = node.attributes['src'];
		    width = parseInt(node.attributes['width']);
		    height = parseInt(node.attributes['height']);
		    originalWidth = parseInt(node.attributes['originalwidth']);
		    originalHeight = parseInt(node.attributes['originalheight']);
		}
	}
}
