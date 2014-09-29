package flare.materials.filters 
{
	import flare.flsl.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class ColorMatrixFilter extends FLSLFilter 
	{
		[Embed(source = "../shaders/colorMatrix.flsl.compiled", mimeType = "application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		public static const GRAY:Vector.<Number> = Vector.<Number>( [ 0.212671, 0.715160, 0.072169, 0,
																	  0.212671, 0.715160, 0.072169, 0, 
																	  0.212671, 0.715160, 0.072169, 0,
																	  0, 0, 0, 1 ] );
		
		private var _values:Vector.<Number>;

		/**
		 * Creates a new ColorMatrixFilter
		 * @param	values a vector with 16 float values representing a 4x4 matrix.
		 */
		public function ColorMatrixFilter( values:Vector.<Number> = null ) 
		{
			super( data, null, "colorMatrix" );
			
			if ( !values ) values = Vector.<Number>([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);
			
			params.matrix.value = values;
		}
		
		public function get values():Vector.<Number> 
		{
			return params.matrix.value;
		}
		
		public function set values(value:Vector.<Number>):void 
		{
			params.matrix.value = value;
		}
	}

}