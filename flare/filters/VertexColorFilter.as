package flare.materials.filters 
{
	import flare.flsl.*;
	import flare.materials.*;
	import flash.display.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class VertexColorFilter extends FLSLFilter
	{
		[Embed(source="../shaders/vertexColors.flsl.compiled", mimeType="application/octet-stream")]
		private static var flsl:Class;		
		private static var data:ByteArray = new flsl;
		
		public function VertexColorFilter( channel:int = 0, blendMode:String = BlendMode.MULTIPLY ) 
		{
			super( data, blendMode );
		}
	}
}