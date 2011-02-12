package utils 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.containers.Panel;
	import mx.core.UIComponent;
	/**
	 * ...
	 * @author Julian Garamendy
	 */
	public class PanelDragger 
	{
		private var _panel:Panel;
		private var _titleBar:UIComponent;
		
		public function PanelDragger( panel:Panel, titleBar:UIComponent ) 
		{
			_panel = panel;
			_titleBar = titleBar;
			
			_titleBar.addEventListener(MouseEvent.MOUSE_DOWN,handleDown);
			_titleBar.addEventListener(MouseEvent.MOUSE_UP,handleUp);
		}
		
        private function handleDown(e:Event):void{
            _panel.startDrag();
        }
        private function handleUp(e:Event):void{
            _panel.stopDrag();
        }		
		
	}

}