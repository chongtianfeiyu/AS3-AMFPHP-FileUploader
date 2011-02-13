package components  
{
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.net.FileReference;
	import mx.containers.Panel;
	import mx.events.FlexEvent;
	import net.pixeltoys.amfuploader.FileUploader;
	import net.pixeltoys.amfuploader.remoting.events.RemoteExceptionEvent;
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
			var pd:PanelDragger = new PanelDragger( this, this.titleBar );			
			
			_form.txtMessage.text = "Please click the Browse button.";
			_form.btnBrowse.addEventListener( FlexEvent.BUTTON_DOWN, handleBrowseFileRequest );
			_form.btnUpload.addEventListener( FlexEvent.BUTTON_DOWN, handleUploadFileRequest );			
			_form.btnCancel.addEventListener( FlexEvent.BUTTON_DOWN, handleCancel );
			
			_fileUploader = new FileUploader( amfChannelId, amfGateway, false );
			_fileUploader.addEventListener( Event.SELECT, handleFileSelect );
			_fileUploader.addEventListener( Event.COMPLETE, handleFileUploaded );
			_fileUploader.addEventListener( ErrorEvent.ERROR, handleError );
		}				
		
		private function reset():void {
			// Reset UI and filereference
			//_form.txtFileSelected.text = "...";
			_form.btnUpload.enabled = false;
			_fileUploader.reset();
		}
		
		
		// Called to add a file for upload 
		private function browseFile():void { 
			_fileUploader.browse();
		} 
		// Called when a file is selected 
		private function handleFileSelect(e:Event):void 		
		{ 
			_form.txtMessage.text = "Please click the Upload button.";
			generatePreview();
			_form.btnUpload.enabled = true;
		} 		
		
		private function generatePreview():void 
		{
			var extension:String = getExtension(_fileUploader.fileVO.filename);
			var filetypes:Array = ["JPG", "jpg", "JPEG", "jpeg", "PNG", "png"];
			if ( filetypes.indexOf(extension) >= 0)
			{
				_previewLoader = new Loader();
				_previewLoader.contentLoaderInfo.addEventListener( Event.INIT, handlePreviewLoaded );
				_previewLoader.loadBytes( _fileUploader.fileVO.filedata );
				if (_form.previewContainer.numChildren > 0) _form.previewContainer.removeChild( _form.previewContainer.getChildAt(0) );
				_form.previewContainer.addChild( _previewLoader );
			}
		}
		
		private function handlePreviewLoaded(e:Event):void 
		{
			_previewLoader.content.width = 160;
			_previewLoader.content.height = 90;
			_previewLoader.x = int( (_previewLoader.parent.width - _previewLoader.width) / 2);
		}

		// Called when upload file is clicked
		private function uploadFile():void
		{		   
			_fileUploader.upload();
		   _form.txtMessage.text = "Uploading file. Please wait.";
		}		
		
		////////////////
		
		private function handleUploadFileRequest(e:FlexEvent):void 
		{
			uploadFile();
		}
		
		private function handleBrowseFileRequest(e:FlexEvent):void 
		{
			browseFile();
		}
		
		private function handleCancel(e:FlexEvent):void 
		{
			_form.txtMessage.text = "You have cancelled.";
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
		
		private function handleError(e:ErrorEvent):void 
		{
			reset();
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