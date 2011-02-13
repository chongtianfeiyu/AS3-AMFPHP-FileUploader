package utils 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.containers.Panel;
	import mx.core.UIComponent;
	/**
	 * Allows a Flex Panel to be dragged by its TitleBar.
	 * @author Julian Garamendy
	 */
	public class PanelDragger 
	{
		private var _panel:Panel;
		private var _titleBar:UIComponent;
		
		public function PanelDragger() 
		{
		}
		
		public function hook(panel:Panel, titleBar:UIComponent ):void
		{
			_panel = panel;
			_titleBar = titleBar;
			_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, handleDown);
			_titleBar.addEventListener(MouseEvent.MOUSE_UP, handleUp);
		}
		
		public function unhook():void 
		{
			_titleBar.removeEventListener(MouseEvent.MOUSE_DOWN, handleDown);
			_titleBar.removeEventListener(MouseEvent.MOUSE_UP, handleUp);
			_panel.stopDrag();
			_panel = null;
			_titleBar = null;
		}
		
		///////
		
        private function handleDown(e:Event):void
		{
            if(_panel) _panel.startDrag();
        }
        private function handleUp(e:Event):void
		{
            if(_panel) _panel.stopDrag();
        }		
		
	}

}