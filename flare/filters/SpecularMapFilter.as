package flare.materials.filters 
{
	import flare.core.*;
	import flare.flsl.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad.
	 */
	public class SpecularMapFilter extends FLSLFilter 
	{
		[Embed(source = "../shaders/specularMap.flsl.compiled", mimeType = "application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		public function SpecularMapFilter( texture:Texture3D = null, power:Number = 50, level:Number = 1, channel:int = 0 ) 
		{
			super( data, null );
			
			params.texture.value = texture;
			params.channel.value = Vector.<Number>([channel]);
			params.powerLevel.value = Vector.<Number>([power, level, 0, 0]);
			params.repeat.value = Vector.<Number>([ 1, 1 ] );
			params.offset.value = Vector.<Number>([ 0, 0 ] );
		}
		
		public function get offsetX():Number
		{
			return params.offset.value[ 0 ];
		}
		
		public function set offsetX( value:Number ):void
		{
			params.offset.value[ 0 ] = value;
		}
		
		public function get offsetY():Number
		{
			return params.offset.value[ 1 ];
		}
		
		public function set offsetY( value:Number ):void
		{
			params.offset.value[ 1 ] = value;
		}
		
		public function get repeatX():Number
		{
			return params.repeat.value[ 0 ];
		}
		
		public function set repeatX( value:Number ):void
		{
			params.repeat.value[ 0 ] = value;
		}
		
		public function get repeatY():Number
		{
			return params.repeat.value[ 1 ];
		}
		
		public function set repeatY( value:Number ):void
		{
			params.repeat.value[ 1 ] = value;
		}
		
		public function get texture():Texture3D 
		{
			return params.texture.value;
		}
		
		public function set texture(value:Texture3D):void 
		{
			params.texture.value = value;
		}
		
		public function get channel():int 
		{
			return params.channel.value[0];
		}
		
		public function set channel(value:int):void 
		{
			params.channel.value[ 0 ] = value;
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