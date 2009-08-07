package com.digg.services.response
{
	import com.digg.model.Model;
	
	import flash.events.*;
	import flash.net.*;
	import flash.xml.*;

	[Event(name="complete", type="flash.events.Event")]
	[Event(name="close", type="flash.events.Event")]
	[Event(name="error", type="flash.events.ErrorEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	public class Response extends EventDispatcher implements IResponse
	{
		protected var request:URLRequest;
		protected var loader:URLLoader;
		protected var items:Array;
		protected var meta:ResponseMetaData;
		protected var model:Model;
		protected var HTTPStatus:uint;
		
		public function Response(request:URLRequest=null)
		{
			super();

			if (request)
			{
				load(request);
			}
		}

		public function get loaded():Boolean
		{
			return loader ? (loader.bytesTotal > 0 && loader.bytesLoaded == loader.bytesTotal) : false;
		}

		public function load(request:URLRequest):void
		{
			this.request = request;
			
			if (loader)
			{
				removeLoaderEventListeners();
				loader.close();
			}
			
			loader = new URLLoader();
			addLoaderEventListeners();
			loader.load(this.request);
		}

		public function cancel():void
		{
			if (loader)
			{
				loader.close();
				dispatchEvent(new Event(Event.CLOSE));
			}
		}
	
		public function getURL():String
		{
			var url:String = request.url;
			if (request.data && request.method == 'GET')
			{
				url += '?' + request.data.toString();
			}
			return url;
		}
		
		public function getBody():XMLDocument
		{
			var doc:XMLDocument = new XMLDocument();
			doc.ignoreWhite = true;
			doc.parseXML(loader.data);
			return doc;
		}

		public function getItems():Array
		{
			return items;
		}
				
		public function getItem():*
		{
			return (items) ? items.shift() : null;
		}
		
		public function getMeta():ResponseMetaData
		{
			return meta;
		}
		
		public function useModel(model:Model):void
		{
			this.model = model;
		}
		
		public function get bytesLoaded():int
		{
			return loader.bytesLoaded;
		}
		
		public function get bytesTotal():int
		{
			return loader.bytesTotal;
		}

		protected function addLoaderEventListeners():void
		{
			loader.addEventListener(Event.COMPLETE, onRequestLoaded);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			loader.addEventListener(ProgressEvent.PROGRESS, onRequestProgress);
			loader.addEventListener(ErrorEvent.ERROR, onRequestError);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onRequestError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onRequestError);
		}

		protected function removeLoaderEventListeners():void
		{
			loader.removeEventListener(Event.COMPLETE, onRequestLoaded);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			loader.removeEventListener(ProgressEvent.PROGRESS, onRequestProgress);
			loader.removeEventListener(ErrorEvent.ERROR, onRequestError);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onRequestError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onRequestError);
		}

		protected function onHTTPStatus(event:HTTPStatusEvent):void
		{
			HTTPStatus = event.status;
			if (event.status != 0)
			{
				trace('got HTTP status: ' + event.status);
			}
		}

		protected function onRequestError(event:ErrorEvent):void
		{
			trace("got error in Response... throwing a new one");
			var errorEvent:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR, false, false, event.text);
			errorEvent.text += "\n" + (event.target as URLLoader).data;

			event.stopImmediatePropagation();
			removeLoaderEventListeners();
			dispatchEvent(errorEvent);
		}

		protected function onRequestProgress(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}

		protected function onRequestLoaded(event:Event):void
		{
			var success:Boolean = false;
			var status:uint = HTTPStatus;
			var error:String;

			/*
			 * NOTE: Flash does not correctly receive the HTTP status from most browsers,
			 * so we have to assume that a status of 0 means succcess.
			 */
			if (status == 200 || status == 0)
			{
				var body:XMLDocument = getBody();
				loadMeta(body.firstChild);
				loadItems(body.firstChild);
				success = true;
			}
			else
			{
				error = getErrorMessage();
			}

			var event:Event;
			if (success)
			{
				event = new Event(Event.COMPLETE);
			}
			else
			{
				event = new ErrorEvent(ErrorEvent.ERROR, false, false, error);
			}
			removeLoaderEventListeners();
			dispatchEvent(event);
		}

		protected function getErrorMessage():String
		{
			var message:String = 'Unknown error';
			var body:XMLDocument = getBody();
			
			if (body && body.hasChildNodes() && body.firstChild.nodeName == 'error')
			{
				message = body.firstChild.attributes.message;
			}
			else
			{
				switch (HTTPStatus)
				{
					case 404:
						message = 'Not found';
						break;
						
					case 503:
						message = 'Server error';
						break;
				}
			}
			
			return message;
		}

		protected function loadMeta(node:XMLNode):void
		{
			meta = ResponseMetaData.fromXML(node);
		}

		protected function loadItems(node:XMLNode):uint
		{
			return 0;
		}
	}
}