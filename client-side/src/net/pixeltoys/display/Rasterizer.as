package net.pixeltoys.display 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * Rasterizer creates a BitmapData instance with the contents of the specified DisplayObject instance.
	 * @author Julian Garamendy
	 */
	public class Rasterizer
	{
		
		public function Rasterizer() 
		{
		}
		
		/**
		 * Returns a BitmapData instance with the contents of the specified DisplayObject instance.
		 * @param	display_object
		 * @param	use_backgrond
		 * @param	bg_color
		 * @return
		 */
		public function rasterize( dsp_obj:DisplayObject, use_backgrond:Boolean = false, bg_color:uint = 0 ):BitmapData
		{
			var rect:Rectangle = dsp_obj.getBounds( dsp_obj );
			var bmpData:BitmapData = new BitmapData( rect.width, rect.height, true, 0 );
			//
			if (use_backgrond) bmpData.fillRect( new Rectangle(0, 0, bmpData.width, bmpData.height), bg_color );
			//
			var mx:Matrix = new Matrix();
			mx.translate( -rect.x, -rect.y );
			//
			bmpData.draw( dsp_obj, mx );
			return bmpData;
		}
		
	}

}