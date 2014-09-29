package flare.materials.filters 
{
	import flare.flsl.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad.
	 */
	public class SpecularFilter extends FLSLFilter 
	{
		[Embed(source = "../shaders/specular.flsl.compiled", mimeType = "application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		public function SpecularFilter( power:Number = 50, level:Number = 1 ) 
		{
			super( data, null );
			
			params.powerLevel.value = Vector.<Number>([power, level, 0, 0]);
		}
		
		public function get power():Number 
		{
			return params.powerLevel.value[0];
		}
		
		public function set power(value:Number):void 
		{
			params.powerLevel.value[0] = value;
		}
		
		public function get level():Number 
		{
			return params.powerLevel.value[1];
		}
		
		public function set level(value:Number):void 
		{
			params.powerLevel.value[1] = value;
		}
	}
}