package net.pixeltoys.amfuploader 
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import net.pixeltoys.amfuploader.remoting.events.RemoteExceptionEvent;
	import net.pixeltoys.amfuploader.remoting.events.RemoteResultEvent;
	import net.pixeltoys.amfuploader.remoting.services.RemoteFileService;
	import net.pixeltoys.amfuploader.remoting.vo.FileVO;
	
	/**
	 * ...
	 * @author Julian Garamendy
	 */
	public class FileUploader extends EventDispatcher 
	{
		
		private var _amfChannelId:String = "my-amfphp";
		private var _amfGateway:String = "http://localhost/amfphp/gateway.php";
		
		private var _service:RemoteFileService;
		
		private var _fileReference:FileReference;
		private var _fileVO:FileVO;		
		private var _errorMessage:String;
		
		public var automatic:Boolean;
		
		public function FileUploader( amfChannelId:String, amfGateway:String, automatic:Boolean = false  ) 
		{
			_amfChannelId = amfChannelId;
			_amfGateway = amfGateway;
			this.automatic = automatic;
			super(null);
			init();
		}
		
		/**
		 * Opens dialog window prompting the user to select a file for upload.
		 */
		public function browse():void { 
		   _fileReference = new  FileReference(); 
		   _fileReference.browse(); 
		   _fileReference.addEventListener(Event.SELECT, handleFileSelect);
		   _fileReference.addEventListener(Event.CANCEL, handleFileSelectCancel);
		}		
		
		/**
		 * Uploads the previously selected file using the specified filename.
		 * The browse() method must be called before this method.
		 * 
		 * @param	filename The new name for the uploaded file. If null, the name of the file in the local disk is used instead.
		 */
		public function upload( filename:String = null ):void
		{
			if (filename) _fileVO.filename = filename;
			_service.upload( _fileVO );
		}
		
		/**
		 * Reset
		 */
		public function reset():void
		{
			_fileReference = new FileReference();
			_fileVO = new FileVO();
		}
		
		private function init():void 
		{
			// Create a new service instance
			_service = new RemoteFileService( _amfChannelId, _amfGateway );
			_service.addEventListener(RemoteExceptionEvent.REMOTE_EXCEPTION, handleRemoteExceptionEvent);
			_service.addEventListener(RemoteResultEvent.UPLOAD_STATUS, handleRemoteResultEvent);
			reset();
		}
		
		private function createFileVO():void 
		{
		   // Create a new FileVO instance
		   _fileVO = new FileVO();		   
		   var data:ByteArray = new ByteArray(); 
		   //Read the bytes into bytearray var
		   _fileReference.data.readBytes(data, 0, _fileReference.data.length); 
		   _fileVO.filename = _fileReference.name;
		   _fileVO.filedata = data;		   
		}
		
		//////////////////
		// Event Handlers
		
		// Called when a file is selected 
		private function handleFileSelect(event:Event):void
		{ 
			_fileReference.removeEventListener( Event.SELECT, handleFileSelect );
			_fileReference.removeEventListener( Event.CANCEL, handleFileSelectCancel);
			//
			_fileReference.addEventListener( Event.COMPLETE, handleFileLoadComplete );
			_fileReference.load();
		}
		
		private function handleFileSelectCancel(e:Event):void 
		{
			_fileReference.removeEventListener( Event.SELECT, handleFileSelect );
			_fileReference.removeEventListener( Event.CANCEL, handleFileSelectCancel);
			//
			dispatchEvent( new Event( Event.CANCEL ) );
		}
		
		
		// Called when the file contents are loaded int othe _fileReference object
		private function handleFileLoadComplete(e:Event):void 
		{
			createFileVO();
			dispatchEvent( new Event( Event.SELECT ) );
			if (automatic) upload();
		}
		
		// Called when the file was completely uploading
		private function handleRemoteResultEvent(event:RemoteResultEvent):void
		{
			//_uploadedFilename = _fileVO.filename;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		// Called in case of an error
		private function handleRemoteExceptionEvent(event:RemoteExceptionEvent):void
		{
			_errorMessage = event.message;
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR ) );
		}
		
		/**
		 * Keeps a description of the error message returned by the server.
		 */
		public function get errorMessage():String { return _errorMessage; }
		
		/**
		 * Selected File Reference
		 */
		public function get fileReference():FileReference { return _fileReference; }
		
		public function get fileVO():FileVO { return _fileVO; }
		
		
		
		
		
	}

}