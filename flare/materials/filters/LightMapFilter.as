package flare.materials.filters 
{
	import flare.core.*;
	import flare.flsl.*;
	import flash.events.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmmad
	 */
	public class LightMapFilter extends FLSLFilter 
	{
		[Embed(source = "../shaders/lightMap.flsl.compiled", mimeType = "application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		public function LightMapFilter( texture:Texture3D = null )
		{
			super( null, "" );
			
			if ( texture ) {
				texture.wrapMode = Texture3D.WRAP_CLAMP;
				texture.mipMode = Texture3D.MIP_NONE;
			}
			
			this.byteCode = data;
			this.params.texture.value = texture;
		}
	}
}