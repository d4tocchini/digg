package com.digg.services.response
{
	import com.digg.model.Model;
	import com.digg.services.*;
	
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.utils.IDataOutput;
	import flash.xml.XMLDocument;
		
	public interface IResponse extends IEventDispatcher
	{
		function get loaded():Boolean;
		function load(request:URLRequest):void;
		function cancel():void;
		function getURL():String;
		function getBody():XMLDocument;
		function getMeta():ResponseMetaData;
		function getItem():*;
		function getItems():Array;
		function useModel(model:Model):void;
	}
}