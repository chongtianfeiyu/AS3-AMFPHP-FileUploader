package components  
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import mx.containers.Panel;
	import mx.events.FlexEvent;
	import net.pixeltoys.amfuploader.remoting.events.RemoteExceptionEvent;
	import net.pixeltoys.amfuploader.remoting.events.RemoteResultEvent;
	import net.pixeltoys.amfuploader.remoting.services.RemoteFileService;
	import net.pixeltoys.amfuploader.remoting.vo.FileVO;
	import utils.PanelDragger;
	
	/**
	 * ...
	 * @author Julian Garamendy
	 */
	
	
	public class OldUploadPanel extends Panel 
	{
		/**
		 * Specifies the name of the file to be saved on the server.
		 * If left empty the original file name in the local drive is used instead.
		 * In all cases, after the upload is successfull this variable takes the value of the saved filename.
		 */
		public var selectedFilename:String = "";
		public var amfChannelId:String = "my-amfphp";
		public var amfGateway:String = "http://localhost/amfphp/gateway.php";
		
		private var service:RemoteFileService;
		
		private var _fileReference:FileReference;
		private var _fileVO:FileVO;
		private var _previewLoader:Loader;
		
		private var _form:UploadForm;
		
		public function OldUploadPanel() 
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
			
			// Create a new service instance
			service = new RemoteFileService( amfChannelId, amfGateway );			
			service.addEventListener(RemoteExceptionEvent.REMOTE_EXCEPTION, handleRemoteExceptionEvent);
			service.addEventListener(RemoteResultEvent.UPLOAD_STATUS, handleRemoteResultEvent);
		}
		
		
		private function reset():void {
			// Reset UI and filereference
			//_form.txtFileSelected.text = "...";
			_form.btnUpload.enabled = false;
			_fileReference = new FileReference();
		}
		
		
		// Called to add a file for upload 
		private function browseFile():void { 
		   _fileReference = new  FileReference(); 
		   _fileReference.browse(); 
		   _fileReference.addEventListener(Event.SELECT, onFileSelect);
		} 
		// Called when a file is selected 
		private function onFileSelect(event:Event):void
		{ 
			//_form.txtFileSelected.text = _fileReference.name;
			_form.btnUpload.enabled = true;
			// Load the filereference data
			_fileReference.addEventListener( Event.COMPLETE, handleFileLoadComplete );
			_fileReference.load();
			_form.txtMessage.text = "Please click the Upload button.";
		} 
		
		private function handleFileLoadComplete(e:Event):void 
		{
			createFileVO();
			generatePreview();
		}
		
		private function createFileVO():void 
		{
		   // Create a new FileVO instance
		   _fileVO = new FileVO();		   
		   var data:ByteArray = new ByteArray(); 
		   //Read the bytes into bytearray var
		   _fileReference.data.readBytes(data, 0, _fileReference.data.length); 
		   _fileVO.filename = (selectedFilename=="")? _fileReference.name : selectedFilename;
		   _fileVO.filedata = data;
		}
		
		private function generatePreview():void 
		{
			var extension:String = getExtension(_fileVO.filename);
			var filetypes:Array = ["JPG", "jpg", "JPEG", "jpeg", "PNG", "png"];
			if ( filetypes.indexOf(extension) >= 0)
			{
				_previewLoader = new Loader();
				_previewLoader.contentLoaderInfo.addEventListener( Event.INIT, handlePreviewLoaded );
				_previewLoader.loadBytes( _fileVO.filedata );
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
		   service.upload(_fileVO);
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
		
		private function handleRemoteResultEvent(event:RemoteResultEvent):void {
			reset();
			// Show message from the server
			_form.txtMessage.text = "The file was uploaded.";
			selectedFilename = _fileVO.filename;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		private function handleRemoteExceptionEvent(event:RemoteExceptionEvent):void {
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