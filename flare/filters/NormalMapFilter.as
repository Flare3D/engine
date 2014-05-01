package flare.materials.filters
{
	import flare.core.*;
	import flare.flsl.*;
	import flash.events.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class NormalMapFilter extends FLSLFilter
	{
		[Embed( source="../shaders/normalMap.flsl.compiled",mimeType="application/octet-stream" )]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		public function NormalMapFilter( texture:Texture3D = null, channel:int = 0 )
		{
			super( data, null );
			
			params.texture.value = texture;
			params.channel.value = Vector.<Number>([ channel ] );
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
		
		public function set texture( value:Texture3D ):void
		{
			params.texture.value = value;
		}
		
		public function get channel():int
		{
			return params.channel.value[ 0 ];
		}
		
		public function set channel( value:int ):void
		{
			params.channel.value[ 0 ] = value;
		}
	}
}