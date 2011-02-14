package components  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import mx.containers.Panel;
	import mx.events.FlexEvent;
	import net.pixeltoys.amfuploader.FileUploader;
	import net.pixeltoys.display.LocalFilePreview;
	import utils.PanelDragger;
	
	/**
	 * ...
	 * @author Julian Garamendy
	 */
	
	
	public class UploadPanel extends Panel 
	{
		/**
		 * Specifies the name of the file to be saved on the server.
		 * If left empty the original file name in the local drive is used instead.
		 * In all cases, after the upload is successfull this variable takes the value of the saved filename.
		 */
		public var selectedFilename:String = "";
		
		
		public var amfChannelId:String = "my-amfphp";
		public var amfGateway:String = "http://localhost/amfphp/gateway.php";		
		
		private var _form:UploadForm;
		private var _fileUploader:FileUploader;
		
		private var _previewLoader:Loader;
		
		public function UploadPanel() 
		{
			_form = new UploadForm();
			addChild( _form );
		}
		
		override protected function initializationComplete():void 
		{
			super.initializationComplete();
			init();
		}
	
		private function init():void
		{
			var pd:PanelDragger = new PanelDragger();
			pd.hook( this, this.titleBar );			
			
			_form.txtMessage.text = "Please click the Browse button.";
			_form.btnBrowse.addEventListener( FlexEvent.BUTTON_DOWN, handleBrowseFileRequest );
			_form.btnUpload.addEventListener( FlexEvent.BUTTON_DOWN, handleUploadFileRequest );			
			_form.btnCancel.addEventListener( FlexEvent.BUTTON_DOWN, handleCancel );
			
			_fileUploader = new FileUploader( amfChannelId, amfGateway, false );
			_fileUploader.addEventListener( Event.SELECT, handleFileSelect );
			_fileUploader.addEventListener( Event.CANCEL, handleFileSelectCancel );
			_fileUploader.addEventListener( Event.COMPLETE, handleFileUploaded );
			_fileUploader.addEventListener( ErrorEvent.ERROR, handleError );
			
			generatePreview();
		}						
		
		private function reset():void {
			// Reset UI and filereference
			_form.txtMessage.text = "Please click the Browse button.";
			_form.btnUpload.enabled = false;
			_form.btnBrowse.enabled = true;
			_form.btnUpload.enabled = false;
			_fileUploader.reset();
			generatePreview();
		}
		
		// Called when a file is selected 
		private function handleFileSelect(e:Event):void 		
		{ 
			_form.txtMessage.text = "Please click the Upload button.";
			generatePreview();
			_form.btnUpload.enabled = true;
			_form.btnBrowse.enabled = false;
		} 		
		
		private function generatePreview():void 
		{
			var bmpd:BitmapData = new BitmapData(160, 90, false, 0x666666);
			var preview_bmp:Bitmap = new Bitmap( bmpd );
			if (_fileUploader.fileVO.filename)
			{
				var extension:String = getExtension(_fileUploader.fileVO.filename);
				var pr:LocalFilePreview = new LocalFilePreview();
				pr.preview( _fileUploader.fileVO.filedata, extension, bmpd );			
			}
			if (_form.previewContainer.numChildren > 0) _form.previewContainer.removeChild( _form.previewContainer.getChildAt(0) );
			_form.previewContainer.addChild( preview_bmp );
			preview_bmp.x = int( (preview_bmp.parent.width - bmpd.width) / 2);
		}
		
		// Called when upload file is clicked
		private function uploadFile():void
		{		   
			_fileUploader.upload();
			_form.btnUpload.enabled = false;
		   _form.txtMessage.text = "Uploading file. Please wait.";
		}
		
		private function cancel():void 
		{
			reset();
			//_form.txtMessage.text = "You have cancelled.";			
		}
		
		
		////////////////
		
		private function handleUploadFileRequest(e:FlexEvent):void 
		{
			uploadFile();
		}
		
		private function handleBrowseFileRequest(e:FlexEvent):void 
		{
			_fileUploader.browse();
			_form.txtMessage.text = "...";
		}
		
		private function handleCancel(e:FlexEvent):void 
		{
			cancel();
			dispatchEvent( new Event( Event.CANCEL ) );
		}

		private function handleFileUploaded(e:Event):void
		{
			reset();
			// Show message from the server
			_form.txtMessage.text = "The file was uploaded.";
			//selectedFilename = _fileVO.filename;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		private function handleFileSelectCancel(e:Event):void 
		{
			reset();
		}		
		
		private function handleError(e:ErrorEvent):void 
		{
			//reset();
			_form.txtMessage.text = "ERROR: Cannot upload file.";
		}
		
		////////
		
		private function getExtension(url:String):String
		{
			var extension:String = url.substring(url.lastIndexOf(".") + 1, url.length);
			return extension;
		}
			
	}

}