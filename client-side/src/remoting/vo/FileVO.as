package remoting.vo
{
	import flash.utils.ByteArray;
	
	[RemoteClass(alias="FileVO")]
	[Bindable]
	public class FileVO	{
		
		public var filename:String;
		public var filedata:ByteArray;
		
		public function FileVO() {
		}

	}
}