package flare.materials.filters 
{
	import flare.flsl.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class ColorTransformFilter extends FLSLFilter 
	{
		[Embed(source = "../shaders/colorTransform.flsl.compiled", mimeType = "application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		public function ColorTransformFilter( redMultiplier:Number = 1, greenMultiplier:Number = 1, blueMultiplier:Number = 1, alphaMultiplier:Number = 1, redOffset:Number = 0, greenOffset:Number = 0, blueOffset:Number = 0, alphaOffset:Number = 0 )
		{
			super( data, null, "colorTransform" )
			params.multiplier.value = Vector.<Number>( [redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier ] );
			params.offset.value = Vector.<Number>( [redOffset, greenOffset, blueOffset, alphaOffset] );
		}
	}
}