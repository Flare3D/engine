package flare.materials.filters
{
	import flare.flsl.*;
	import flash.display.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class FogFilter extends FLSLFilter
	{
		[Embed( source="../shaders/fog.flsl.compiled",mimeType="application/octet-stream" )]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		public function FogFilter( near:Number = 0, far:Number = 1000, blendMode:String = BlendMode.MULTIPLY )
		{
			super( data, blendMode );
			
			params.nearFar.value = Vector.<Number>( [near, far] );
		}
	}
}