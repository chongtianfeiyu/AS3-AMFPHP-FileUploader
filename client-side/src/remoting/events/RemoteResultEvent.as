package remoting.events
{
	import flash.events.Event;
	public class RemoteResultEvent extends Event {
		
		public static var UPLOAD_STATUS:String = "upload_status";
		public var message:String;
		
		public function RemoteResultEvent(eventType:String, message:String)	{
			super(eventType, false, false);
			this.message = message;
		}

	}
}