package flare.gui 
{
	import flare.core.*;
	import flash.events.*;
	import flash.geom.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Image2D extends Pivot2D
	{
		private static var rect:Rectangle = new Rectangle;
		
		private var _texture:Texture3D;
		private var _frame:TextureFrame;
		
		public var uv:Rectangle;
		public var testPixel:Boolean = true;
		public var scrollRect:Rectangle;
		
		public function Image2D( texture:Texture3D, frame:TextureFrame = null ) 
		{
			super( texture.name );
			
			this.mouseEnabled = true;
			
			_texture = texture;
			
			if ( frame ) {
				this.name = frame.name;
				this.frame = frame;
			} else {
				if ( texture.loaded ) {
					width = texture.width;
					height = texture.height;
				} else
					texture.addEventListener( Event.COMPLETE, completeLoadTextureEvent );
			}
		}
		
		private function completeLoadTextureEvent(e:Event):void 
		{
			texture.removeEventListener( Event.COMPLETE, completeLoadTextureEvent );
			
			if ( width == 0 && height == 0 ) {
				width = _texture.width;
				height = _texture.height;
			}
		}
		
		public function get frame():TextureFrame 
		{
			return _frame;
		}
		
		public function set frame( value:TextureFrame ):void 
		{
			_frame = value;
			
			uv = _frame.uv;
			width = _frame.offset.width;
			height = _frame.offset.height;
			
			mouseRect ||= new Rectangle
			mouseRect.x = _frame.offset.x;
			mouseRect.y = _frame.offset.y;
			mouseRect.width = _frame.width;
			mouseRect.height = _frame.height;
		}
		
		public function get texture():Texture3D 
		{
			return _texture;
		}
		
		override public function testPoint( x:Number, y:Number, includeChildren:Boolean = true ):Pivot2D 
		{
			if ( !testPixel || !_texture.bitmapData )
				return super.testPoint( x, y, includeChildren );
				
			if ( includeChildren && children ) {
				var length:int = children.length;
				for ( var i:int = length - 1; i >= 0; i-- ) {
					var result:Pivot2D = children[i].testPoint( x, y, includeChildren );
					if ( result ) return result;
				}
			}
			
			if ( mouseEnabled && width > 0 && height > 0 ) {
				inv.copyFrom( transform );
				inv.concat( graphics.transform );
				inv.invert();
				var vx:Number = x * inv.a + y * inv.c + inv.tx;
				var vy:Number = x * inv.b + y * inv.d + inv.ty;
				if ( !_frame ) {
					if ( vx > 0 && vy > 0 && vx < width && vy < height ) return this;
				} else {
					vx -= _frame.offset.x;
					vy -= _frame.offset.y;
					if ( vx > 0 && vy > 0 && vx < _frame.width && vy < _frame.height ) {
						var u:Number = (vx / _frame.width) * _frame.uv.width + _frame.uv.x;
						var v:Number = (vy / _frame.height) * _frame.uv.height + _frame.uv.y;
						var alpha:uint = (_texture.bitmapData.getPixel32( u * _texture.width, v * _texture.height ) >> 24) & 0xff;
						if ( alpha > 64 )
							return this;
					}
				}
			}
			
			return null;
		}
		
		override public function draw():void
		{
			if ( !graphics || !visible ) return;
			
			if ( scrollRect ) {
				rect.x = scrollRect.x * graphics.transform.a + scrollRect.y * graphics.transform.c + graphics.transform.tx;
				rect.y = scrollRect.x * graphics.transform.b + scrollRect.y * graphics.transform.d + graphics.transform.ty;
				rect.width = scrollRect.width * graphics.transform.a + scrollRect.height * graphics.transform.c;
				rect.height = scrollRect.width * graphics.transform.b + scrollRect.height * graphics.transform.d;
				graphics.setScrollRect( rect );
			}
			
			updateTransform();
			
			graphics.beginTextureFill( _texture, tint );
			if ( _frame ) 
				graphics.drawImage( _frame.offset.x, _frame.offset.y, _frame.width, _frame.height, uv, transform );
			else
				graphics.drawImage( 0, 0, width, height, uv, transform );
			
			if ( children ) {
				var length:int = children.length;
				for ( var i:int = 0; i < length; i++ ) children[i].draw()
			}			
			
			if ( scrollRect )
				graphics.setScrollRect( null );
		}
	}
}