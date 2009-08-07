package com.stamen.display
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.*;

	public class DraggableSprite extends Sprite
	{
		public var dragRect:Rectangle;
		
		protected var _draggable:Boolean;
		protected var _dragging:Boolean = false;

		public function DraggableSprite(draggable:Boolean=true)
		{
			super();
			this.draggable = draggable;
		}
		
		public function set draggable(isDraggable:Boolean):void
		{
			if (isDraggable != _draggable)
			{
				var wasDraggable:Boolean = _draggable;
				_draggable = isDraggable;

				if (_draggable && !wasDraggable)
				{
					addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
				else if (!_draggable && wasDraggable)
				{
					removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

					if (_dragging)
					{
						onMouseUp(null);
					}
				}
				
				buttonMode = _draggable;
			}
		}

		public function get draggable():Boolean
		{
			return _draggable;
		}
		
		public function get dragging():Boolean
		{
			return _dragging;
		}

		override public function startDrag(lockCenter:Boolean=false, bounds:Rectangle=null):void
		{
			if (!_dragging)
			{
				super.startDrag(lockCenter, bounds);
				_dragging = true;
				addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}

		override public function stopDrag():void
		{
			if (_dragging)
			{
				super.stopDrag();
				_dragging = false;
				removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}

		protected function onMouseDown(event:MouseEvent):void
		{
			startDrag();
			parent.setChildIndex(this, parent.numChildren - 1);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			stopDrag();
		}
	}
}