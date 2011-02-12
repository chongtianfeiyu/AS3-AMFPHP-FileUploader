package remoting.services
{
	import flash.utils.ByteArray;
	import mx.core.FlexGlobals;
	
	import mx.core.Application;
	import mx.rpc.events.ResultEvent;
	
	import remoting.events.RemoteResultEvent;
	import remoting.vo.FileVO;
	
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