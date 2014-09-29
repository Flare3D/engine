package flare.materials.filters 
{
	import flare.core.*;
	import flare.flsl.*;
	import flash.display.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad.
	 */
	public class PlanarMapFilter extends FLSLFilter 
	{
		[Embed(source = "../shaders/planarMap.flsl.compiled", mimeType = "application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		public static const PROJECTED:String = "projected"
		public static const SPHERICAL:String = "spherical"
		
		public function PlanarMapFilter( texture:Texture3D = null, blendMode:String = BlendMode.MULTIPLY, techniqueName:String = PROJECTED ) 
		{
			super( data, blendMode, techniqueName );
			
			params.texture.value = texture;
		}
	}
}