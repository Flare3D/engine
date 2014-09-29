package flare.materials.filters 
{
	import flare.flsl.*;
	import flash.display.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class ColorFilter extends FLSLFilter 
	{
		[Embed(source = "../shaders/color.flsl.compiled", mimeType = "application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		public function ColorFilter( color:int = 0xffffff, alpha:Number = 1, blendMode:String = BlendMode.MULTIPLY ) 
		{
			super( data, blendMode );
			
			params.color.value = new Vector.<Number>(4, true);
			
			this.color = color;
			this.a = alpha;
		}
		
		public function set r( value:Number ):void 
		{
			params.color.value[0] = value;
		}
		
		public function set g( value:Number ):void 
		{
			params.color.value[1] = value;
		}
		
		public function set b( value:Number ):void 
		{
			params.color.value[2] = value;
		}
		
		public function set a( value:Number ):void 
		{
			params.color.value[3] = value;
		}
		
		public function get r():Number { return params.color.value[0] }
		public function get g():Number { return params.color.value[1] }
		public function get b():Number { return params.color.value[2] }
		public function get a():Number { return params.color.value[3] }
		
		public function set color( value:uint ):void
		{
			var a:Number = ( uint( value >> 24 ) & 0xff ) / 0xff;
			var r:Number = ( uint( value >> 16 ) & 0xff ) / 0xff;
			var g:Number = ( uint( value >> 8 ) & 0xff ) / 0xff;
			var b:Number = ( uint( value >> 0 ) & 0xff ) / 0xff;
			params.color.value[0] = r;
			params.color.value[1] = g;
			params.color.value[2] = b;
			params.color.value[3] = a;
		}
		
		public function get color():uint
		{
			return (params.color.value[3] * 255) << 24 ^ (params.color.value[0] * 255) << 16 ^ (params.color.value[1] * 255) << 8 ^ (params.color.value[2] * 255);
		}
	}
}