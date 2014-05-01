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
	public class TextureMaskFilter extends FLSLFilter 
	{
		[Embed(source = "../shaders/textureMask.flsl.compiled", mimeType = "application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		public static const ALPHA:String = "alpha";
		public static const RED:String = "red";
		public static const GREEN:String = "green";
		public static const BLUE:String = "blue";
		
		public function TextureMaskFilter( texture:Texture3D = null, channel:int = 0, threshold:Number = 0.5, technique:String = ALPHA ) 
		{
			super( data, "" );
			
			params.threshold.value = Vector.<Number>([threshold]);
			params.channel.value = Vector.<Number>([channel]);
			params.texture.value =  texture;
		}
	}
}