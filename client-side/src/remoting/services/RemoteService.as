package remoting.services
{
	import flash.events.EventDispatcher;
	import mx.core.FlexGlobals;
	import remoting.events.RemoteExceptionEvent;
	
	import mx.core.Application;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.remoting.RemoteObject;
	import mx.managers.CursorManager;

    /**
     * Super class for all remote services that contains some generic methods.
     */
    public class RemoteService extends EventDispatcher
	{
        private static var REMOTE_EXCEPTION:String = "Remote exception";
        private static var NO_MESSAGE:String = "10001";

        protected var remoteObject:RemoteObject;

        private var amfChannelSet:ChannelSet;
			
        /**
         * Constructor accepting an id and destination for the actual RemoteObject to create. An event listener
         * is added for exceptions.
         * @param id String representing the id of the new RemoteObject to create
         * @param destination String representing the destination of the RemoteObject to create
         * @param amfChannelId String representing the Channel of the RemoteObject to create
         * @param amfChannelEndpoint String representing the Endpoint URI of the RemoteObject to create
         */
        public function RemoteService( serviceId:String
                                     , serviceDestination:String
                                     , amfChannelId:String
                                     , amfChannelEndpoint:String
                                     ) 
        {
        	// Create a runtime Channelset for given Channel ID and Endpoinr URI
        	var amfChannel:AMFChannel = new AMFChannel(amfChannelId, amfChannelEndpoint);
            amfChannelSet = new ChannelSet();
            amfChannelSet.addChannel(amfChannel);
        	
        	// Create the remoteObject instance
            this.remoteObject = new RemoteObject(serviceId);
            this.remoteObject.channelSet = amfChannelSet;
            this.remoteObject.destination = serviceDestination;
            this.remoteObject.addEventListener(FaultEvent.FAULT,onRemoteException);
        	
        }

        /**
         * generic fault event handler for all remote object actions. based on the received message/code an action
         * is taken, mostly throwing a new event.
         * @param event FaultEvent received for handling
         */
        public function onRemoteException(event:FaultEvent):void {
            trace('code : ' + event.fault.faultCode +
                  ', message : ' + event.fault.faultString +
                  ',detail : ' + event.fault.faultDetail);
                  
            if (event.fault.faultString == REMOTE_EXCEPTION) {
				this.dispatchEvent(
                        new RemoteExceptionEvent(RemoteExceptionEvent.REMOTE_EXCEPTION,
                                "unknown problem occurred during a remote call : " + event.fault.message));
            } else if (event.fault.faultCode == NO_MESSAGE) { 
                this.dispatchEvent(
                        new RemoteExceptionEvent(RemoteExceptionEvent.REMOTE_EXCEPTION,
                                event.fault.faultString));
            } else {
            	this.dispatchEvent(
                        new RemoteExceptionEvent(RemoteExceptionEvent.REMOTE_EXCEPTION,
                                "unknown runtime problem occurred during a remote call : " + event.fault.message));
            }
        }
    }
}