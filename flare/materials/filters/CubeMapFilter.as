package flare.materials.filters 
{
	import flare.core.*;
	import flare.flsl.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class CubeMapFilter extends FLSLFilter 
	{
		[Embed(source = "../shaders/cubeMap.flsl.compiled", mimeType = "application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		public function CubeMapFilter( texture:Texture3D = null, level:Number = 1, blendMode:String = BlendMode.MULTIPLY ) 
		{
			super( data, blendMode );
			
			this.texture = texture;
			
			params.level.value = Vector.<Number>([level]);
		}
		
		public function get level():Number 
		{
			return params.level.value[0];
		}
		
		public function set level(value:Number):void 
		{
			params.level.value[0] = value;
		}
		
		public function get texture():Texture3D
		{
			return params.texture.value;
		}
		
		public function set texture( value:Texture3D ):void 
		{
			params.texture.value = value;
		}
	}
}