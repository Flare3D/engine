package flare.gui
{
	import flare.core.*;
	import flash.geom.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class TextureFont2D extends Texture3D 
	{
		public var base:Number;
		public var pages:uint;
		public var outline:Number;
		public var padding:Rectangle;
		public var chars:Vector.<TextureFontChar>;
		
		public var lineHeight:Number;
		public var fontWidth:Number;
		public var fontHeight:Number;
		
		public function TextureFont2D( request:*, xml:XML ) 
		{
			super( request )
			
			lineHeight = xml.common.@lineHeight;
			base = xml.common.@base;
			fontWidth = xml.common.@scaleW;
			fontHeight = xml.common.@scaleH;
			pages  = xml.common.@pages;
			outline = xml.info.@outline;
			
			var p:Array = xml.info.@padding.toString().split( "," );
			padding = new Rectangle();
			padding.top = p[0];
			padding.left = p[1];
			padding.bottom = p[2];
			padding.right = p[3];
			
			chars = new Vector.<TextureFontChar>(256, true);
			for each ( var x:XML in xml.chars.children() )
				chars[uint(x.@id)] = new TextureFontChar( x );
		}
		
		public function getTextWidth( string:String, startAt:int = 0, singleLine:Boolean = false ):Number
		{
			var cursorX:Number = 0;
			var maxWidth:Number = 0;
			var length:int = string.length;
			
			for ( var i:int = startAt; i < length; i++ ) {
				var id:int = string.charCodeAt(i);
				var ch:TextureFontChar = chars[id];
				if ( id == 10 ) {
					if ( cursorX > maxWidth ) maxWidth = cursorX;
					if ( singleLine ) return maxWidth + outline;
					cursorX = outline;
				}
				if ( !ch ) continue;
				cursorX += ch.xAdvance + outline;
			}
			
			if ( cursorX > maxWidth ) maxWidth = cursorX;
			return maxWidth + outline;
		}
		
		public function getTextHeight( string:String ):Number
		{
			return getNumLines( string ) * lineHeight + outline * 2;
		}
		
		public function getNumLines( string:String ):uint
		{
			var count:int = 1;
			var index:int = string.indexOf( "\n", index );
			while ( index != -1 ) {
				index = string.indexOf( "\n", index + 1 );
				count++;
			}
			return count;
		}
	}
}
