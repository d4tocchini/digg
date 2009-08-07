package com.digg.model
{
    public class MediaSize
    {
        // 80x80, cropped
        public static const THUMBNAIL:String = 't';
        // 30x30, cropped (for user history pages) 
        public static const HISTORY:String = 'a';
        // 48x48, cropped 
        public static const SMALL:String = 's';
        // 120x120, cropped
        public static const MEDIUM:String = 'm';
        // 160x160, cropped
        public static const LARGE:String = 'l';
        // 160px in largest dimension, uncropped
        public static const PERMALINK:String = 'p';
    }
}