package net.pixeltoys.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Julian Garamendy
	 */
	public class LocalFilePreview extends EventDispatcher 
	{
		private var _fileData:ByteArray;
		private var _fileExtension:String;
		private var _bitmapData:BitmapData;
		
		private var _fileTypes:Dictionary;
		private var _previewLoader:Loader;
		
		public function LocalFilePreview( ) 
		{
			super();
			populateFileTypes();
		}
		
		public function preview(file_data:ByteArray, file_extension:String, bitmap_data:BitmapData):void 
		{
			_bitmapData = bitmap_data;
			_fileData = file_data;
			_fileExtension = file_extension;
			
			switch (_fileTypes[_fileExtension]) 
			{
				case "bitmap":
					previewBitmap();
					break;
				case "swf":
					previewSWF();
					break;
				default:
					previewNothing();
				break;
			}
			
		}
		
		private function previewBitmap():void 
		{
			_previewLoader = new Loader();
			_previewLoader.contentLoaderInfo.addEventListener( Event.INIT, handlePreviewLoaded );
			_previewLoader.loadBytes(_fileData );
		}
		
		private function previewSWF():void 
		{
			
		}
		
		private function previewNothing():void 
		{
			
		}
		
		private function handlePreviewLoaded(e:Event):void 
		{
			rasterizePreview();
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		private function rasterizePreview():void 
		{
			var _rast:Rasterizer = new Rasterizer();
			var bmpd:BitmapData = _rast.rasterize( _previewLoader.content ); 
			var mx:Matrix = new Matrix();
			var sx:Number = _bitmapData.width / _previewLoader.content.width;
			var sy:Number = _bitmapData.height / _previewLoader.content.height;
			mx.scale(sx, sy);
			_bitmapData.draw( bmpd, mx, null, null, null, true );
		}
		
		
		///////
		
		private function populateFileTypes():void 
		{
			_fileTypes = new Dictionary();
			_fileTypes["jpg"] 	= "bitmap";
			_fileTypes["JPG"] 	= "bitmap";
			_fileTypes["jpeg"] 	= "bitmap";
			_fileTypes["JPEG"] 	= "bitmap";
			_fileTypes["png"] 	= "bitmap";
			_fileTypes["PNG"] 	= "bitmap";
			_fileTypes["swf"] 	= "swf";
			_fileTypes["SWF"] 	= "swf";
		}
		
		public function get bitmapData():BitmapData { return _bitmapData; }
		
		/////////////
		
	}

}