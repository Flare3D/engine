package flare.materials.filters 
{
	import flare.core.*;
	import flare.materials.*;
	import flare.flsl.*;
	import flare.system.*;
	import flash.display.*;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author Ariel Nehmad
	 */
	public class EnvironmentMapFilter extends FLSLFilter
	{
		[Embed(source="../shaders/environmentMap.flsl.compiled", mimeType="application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		public static const PER_VERTEX:String = "perVertex";
		public static const PER_PIXEL:String = "perPixel";
		
		public function EnvironmentMapFilter( texture:Texture3D = null, blendMode:String = BlendMode.MULTIPLY, alpha:Number = 1, techniqueName:String = PER_PIXEL ) 
		{
			super( data, blendMode, techniqueName );
			
			params.alpha.value = new Vector.<Number>(4);
			params.scale.value = Vector.<Number>( [0.5, -0.5] );
			
			this.alpha = alpha;
			this.texture = texture;
		}		
		
		public function get texture():Texture3D { return params.texture.value; }
		
		public function set texture(value:Texture3D):void 
		{
			params.texture.value = value;
		}
		
		public function get alpha():Number 
		{
			return params.alpha.value[0];
		}
		
		public function set alpha(value:Number):void 
		{
			params.alpha.value[0] = value;
		}
		
		public function get scaleX():Number 
		{
			return params.scale.value[0];
		}
		
		public function set scaleX(value:Number):void 
		{
			params.scale.value[0] = value;
		}
		
		public function get scaleY():Number 
		{
			return params.scale.value[1];
		}
		
		public function set scaleY(value:Number):void 
		{
			params.scale.value[1] = value;
		}
	}
}