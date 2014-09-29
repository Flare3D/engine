package flare.materials.filters 
{
	import flare.flsl.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad.
	 */
	public class FlipNormalsFilter extends FLSLFilter 
	{
		[Embed(source = "../shaders/flipNormals.flsl.compiled", mimeType = "application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		public function FlipNormalsFilter() 
		{
			super( data, "" );
		}
	}
}