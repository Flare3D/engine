package flare.gui
{
	import flash.geom.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Text2D extends Pivot2D
	{
		public static const CENTER_X:uint = 1 << 1;
		public static const CENTER_Y:uint = 1 << 2;
		public static const CENTER_XY:uint = CENTER_X + CENTER_Y;
		public static const RIGHT:uint = 1 << 3;
		
		private var _font:TextureFont2D;
		
		public var align:uint;
		public var text:String;
		
		public function Text2D( font:TextureFont2D, text:String = "" ) 
		{
			super( font.name );
			
			_font = font;
			
			this.text = text;
		}
		
		public function getTextWidth():Number
		{
			return _font.getTextWidth( text );
		}
		
		public function getTextHeight():Number
		{
			return _font.getTextHeight( text );
		}
		
		override public function draw():void 
		{
			if ( !graphics || !visible ) return;
			
			if ( text.length ) {
				graphics.beginTextureFill( _font, tint )
				graphics.drawText( _font, text, 0, 0, align, transform );
			}
			
			super.draw();
		}
	}
}