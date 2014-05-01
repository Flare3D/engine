package flare.materials.filters 
{
	import flare.flsl.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class SelfColorFilter extends FLSLFilter 
	{
		[Embed(source = "../shaders/selfColor.flsl.compiled", mimeType = "application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		private var _color:Vector.<Number> = new Vector.<Number>(4);
		private var _level:Number;
		
		public function SelfColorFilter( color:int = 0x0, level:Number = 1 ) 
		{
			super( data, "" );
			
			_level = level;
			
			params.selfColor.value = _color;
			
			this.color = color;
		}
		
		public function set color( value:uint ):void
		{
			var a:Number = ( uint( value >> 24 ) & 0xff ) / 0xff;
			var r:Number = ( uint( value >> 16 ) & 0xff ) / 0xff;
			var g:Number = ( uint( value >> 8 ) & 0xff ) / 0xff;
			var b:Number = ( uint( value >> 0 ) & 0xff ) / 0xff;
			_color[0] = r;
			_color[1] = g;
			_color[2] = b;
			_color[3] = 1 * _level;
		}
		
		public function get color():uint
		{
			return (_color[3] * 255) << 24 ^ (_color[0] * 255) << 16 ^ (_color[1] * 255) << 8 ^ (_color[2] * 255);
		}
		
		public function get level():Number 
		{
			return _level;
		}
		
		public function set level(value:Number):void 
		{
			_level = value;
			
			this.color = color;
		}
	}
}