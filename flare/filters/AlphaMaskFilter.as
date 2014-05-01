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
	public class AlphaMaskFilter extends FLSLFilter 
	{
		[Embed(source = "../shaders/alphaMask.flsl.compiled", mimeType = "application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		public function AlphaMaskFilter( threshold:Number = 0.5 ) 
		{
			super( data, null );
			
			super.techniqueName = "alphaMask";
			
			params.threshold.value = Vector.<Number>([threshold]);
		}
		
		override public function get techniqueName():String 
		{
			return super.techniqueName;
		}
		
		override public function set techniqueName(value:String):void 
		{
			
		}
		
		override public function get blendMode():String 
		{
			return super.blendMode;
		}
		
		override public function set blendMode(value:String):void 
		{
			
		}
		
		public function get threshold():Number 
		{
			return params.threshold.value[0];
		}
		
		public function set threshold(value:Number):void 
		{
			params.threshold.value[0] = value;
		}
	}
}