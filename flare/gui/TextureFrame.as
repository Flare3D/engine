package flare.gui
{
	import flare.core.*;
	import flash.geom.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class TextureFrame 
	{
		public var name:String;
		public var x:Number = 0;
		public var y:Number = 0;
		public var width:Number = 1;
		public var height:Number = 1;
		public var uv:Rectangle = new Rectangle( 0, 0, 1, 1 );
		public var offset:Rectangle = new Rectangle( 0, 0, 0, 0 );
		
		public function TextureFrame() 
		{
			
		}
		
		public function center( out:Point = null ):Point
		{
			out ||= new Point;
			out.x = width * 0.5;
			out.y = height * 0.5;
			return out;
		}
	}
}