package utils 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.controls.LinkButton;
	import mx.core.UIComponent;
	
	/**
	 * ...
	 * @author Julian Garamendy
	 */
	public class CloseButton extends LinkButton 
	{
		
		[Embed(source="../../assets/close.png")] public var closeButtonPNG:Class;
		private var _component:UIComponent;
		
		public function CloseButton() 
		{
			super();
			setStyle('icon', closeButtonPNG);
			useHandCursor = false;
			width = 16;
            height = 16;
			addEventListener(MouseEvent.CLICK, handleClick );
		}
		
		private function handleClick(e:Event):void 
		{
			
		}
		
		public function addToPanel( component:UIComponent ):void 
		{
			_component = component;
			_component.addChild( this );
			addEventListener(Event.ENTER_FRAME, handleFrameOnce);
		}
		
		private function handleFrameOnce(e:Event):void 
		{
			//removeEventListener( Event.ENTER_FRAME, handleFrameOnce);
			this.x = _component.parent.width - 24;
			this.y = 8;
		}
		
	}

}