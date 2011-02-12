package net.pixeltoys.amfuploader.remoting.services
{
	import flash.utils.ByteArray;
	import mx.core.FlexGlobals;
	import net.pixeltoys.amfuploader.remoting.events.RemoteResultEvent;
	import net.pixeltoys.amfuploader.remoting.vo.FileVO;
	
	import mx.core.Application;
	import mx.rpc.events.ResultEvent;
	
	
	/**
     * Class that extends the RemoteService class, therefore it makes use of the default error handling for
     * remote calls.
     */
	public class RemoteFileService extends RemoteService {
		private static var phpServiceClass:String = "RemoteFile";
		
		public function RemoteFileService(amfChannelId:String, amfChannelEndpoint:String) {
			super("remotefileService", "amfphp", amfChannelId, amfChannelEndpoint);
		}
        
        public function upload(file:FileVO):void
		{
        	remoteObject.source = phpServiceClass;
        	remoteObject.upload.addEventListener( ResultEvent.RESULT, handleRemoteMethod);
            remoteObject.upload(file);
        }
        
        protected function handleRemoteMethod(event:ResultEvent):void {
        	var uploadStatus:String;
        	uploadStatus = event.result.toString();
        	//Alert.show(helloworld);
        	this.dispatchEvent(
        	   new RemoteResultEvent(RemoteResultEvent.UPLOAD_STATUS, uploadStatus));
        }
	}
}