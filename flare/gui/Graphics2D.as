package flare.gui
{
	import avm2.intrinsics.memory.*;
	import flare.core.*;
	import flare.flsl.*;
	import flare.system.*;
	import flare.utils.*;
	import flash.display3D.*;
	import flash.geom.*;
	import flash.system.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Graphics2D
	{
		[Embed(source = "shaders/gui.flsl.compiled", mimeType = "application/octet-stream")]
		private static var GUI_FLSL:Class;
		private static var uvRect:Rectangle = new Rectangle( 0, 0, 1, 1 );
		private static var uvs:Rectangle = new Rectangle( 0, 0, 1, 1 );
		
		/**
		 * Sets a fixed area in pixels to draw. If the area is bigger or smaller than the screen viewport, it will scale to adapt to 
		 * cover the entire screen size while keeping the aspect ractio.
		 */
		public var viewPort:Rectangle;
		public var transform:Matrix = new Matrix;
		
		private var _defaultMaterial:FLSLMaterial;
		private var _reupload:Boolean = true;
		private var _camera:Camera3D = new Camera3D();
		private var _surface:Surface3D;
		private var _vertices:int = 0;
		private var _quads:int = 0;
		private var _material:FLSLMaterial;
		private var _texture:Texture3D;
		private var _dirty:Boolean = true;
		
		private var _vertexColors:Boolean = false;
		private var _red:Number = 1;
		private var _green:Number = 1;
		private var _blue:Number = 1;
		private var _alpha:Number = 1;
		
		public function Graphics2D( material:FLSLMaterial = null ) 
		{
			_material = material;
			_defaultMaterial = new FLSLMaterial( "gui", new GUI_FLSL, null, true );
			_defaultMaterial.upload( Device3D.scene );
			
			build();
			
			expand( 100 );
		}
		
		private function build():void
		{
			if ( _surface ) _surface.dispose();
			
			_surface = new Surface3D( "sprites" );
			_surface.vertexBytes = new ByteArray;
			_surface.indexBytes = new ByteArray;
			_surface.addVertexData( Surface3D.POSITION, 2 );
			_surface.addVertexData( Surface3D.UV0, 2 );
			
			if ( _vertexColors )
				_surface.addVertexData( Surface3D.COLOR0, 4 );
		}
		
		private function expand( quads:int = -1 ):void
		{
			if ( quads == -1 ) {
				quads = _quads;
				if ( quads == 0 ) quads = 1;
			}
			
			var position:uint = _surface.indexBytes.length;
			var vertex:uint = _surface.vertexBytes.length / _surface.sizePerVertex / 4;
				vertex += quads * 4;
				
			if ( vertex >= 65000 ) vertex = 65000;
			
			_surface.vertexBytes.length = vertex * _surface.sizePerVertex * 4;
			_surface.indexBytes.length = vertex / 4 * 12; // 12 = 6 indices x 16bit each.
			_surface.download();
			
			ApplicationDomain.currentDomain.domainMemory = _surface.indexBytes;
			var length:int = _surface.indexBytes.length;
			while( position < length ) {
				si16( _vertices, position );
				si16( _vertices + 1, position + 2 );
				si16( _vertices + 2, position + 4 );
				si16( _vertices + 3, position + 6 );
				si16( _vertices + 2, position + 8 );
				si16( _vertices + 1, position + 10 );
				position += 12; _vertices += 4;
			}
			ApplicationDomain.currentDomain.domainMemory = _surface.vertexBytes;
		}
		
		private function reset():void
		{
			_quads = 0;
			_reupload = true;
		}
		
		private function flush():void
		{
			render();
			reset();
		}
		
		public function clear():void
		{
			reset();
			setupFrame();
		}
		
		public function setScrollRect( rect:Rectangle ):void
		{
			flush();
			
			Device3D.context.setScissorRectangle( rect );
		}
		
		public function beginTextureFill( texture:Texture3D, tint:Vector3D = null ):void
		{
			if ( _texture != texture ) flush();
			
			if ( tint ) {
				_red = tint.x;
				_green = tint.y;
				_blue = tint.z;
				_alpha = tint.w;
			} else {
				_red = 1;
				_green = 1;
				_blue = 1;
				_alpha = 1;
			}
			
			_texture = texture;
		}
		
		public function drawFrame( x:Number, y:Number, frame:TextureFrame, transform:Matrix = null ):void
		{
			drawImage( x, y, frame.width, frame.height, frame.uv, transform );
		}
		
		public function drawImages( images:Vector.<Image2D>, uvsRect:Rectangle = null ):void
		{
			if ( _quads ) flush();
			
			_reupload = true;
			
			var len:int = images.length;
			var index:int = 0;
			var bytes:ByteArray = _surface.vertexBytes;
			var size:int = _surface.sizePerVertex;
			
			if ( _vertices <= len * 4 ) expand( 65000 )
			
			// uv's part.
			uvsRect ||= Graphics2D.uvRect;
			var u0:Number = uvsRect.x;
			var v0:Number = uvsRect.y;
			var u1:Number = uvsRect.width + u0;
			var v1:Number = uvsRect.height + v0;
			
			for ( var i:int = 0; i < len; i++ ) {
				
				var image:Image2D = images[i];
				
				image.updateTransform();
				
				var transform:Matrix = image.transform;
				var x:Number = 0;
				var y:Number = 0;
				var w:Number = image.width;
				var h:Number = image.height;
				var rx:Number = transform.a;
				var ry:Number = transform.b;
				var ux:Number = transform.c;
				var uy:Number = transform.d;
				var tx:Number = transform.tx;
				var ty:Number = transform.ty;
				
				var vx:Number;
				var vy:Number;
				index = _quads * size * 16
				vx = x * rx + y * ux + tx;
				vy = x * ry + y * uy + ty;
				sf32( vx, index );
				sf32( vy, index + 4 );
				sf32( u0, index + 8 );
				sf32( v0, index + 12 );
				index += size * 4;
				vx = w * rx + y * ux + tx;
				vy = w * ry + y * uy + ty;
				sf32( vx, index );
				sf32( vy, index + 4 );
				sf32( u1, index + 8 );
				sf32( v0, index + 12 );
				index += size * 4;
				vx = x * rx + h * ux + tx;
				vy = x * ry + h * uy + ty;
				sf32( vx, index );
				sf32( vy, index + 4 );
				sf32( u0, index + 8 );
				sf32( v1, index + 12 );
				index += size * 4;
				vx = w * rx + h * ux + tx;
				vy = w * ry + h * uy + ty;
				sf32( vx, index );
				sf32( vy, index + 4 );
				sf32( u1, index + 8 );
				sf32( v1, index + 12 );
				
				_quads++;
				
				if ( _quads >= 16250 ) { flush(); _quads = 0; }
			}
			
			if ( _quads > 0 ) flush();
		}
		
		public function drawImage( x:Number, y:Number, w:Number, h:Number, uvsRect:Rectangle = null, transform:Matrix = null ):void
		{
			if ( _quads * 4 >= 65000 ) flush();
			
			if ( _vertices <= _quads * 4 ) expand( 200 );
			
			_reupload = true;
			
			var index:int;
			var bytes:ByteArray = _surface.vertexBytes;
			var size:int = _surface.sizePerVertex;
			
			// uv's part.
			uvsRect ||= Graphics2D.uvRect;
			var u0:Number = uvsRect.x;
			var v0:Number = uvsRect.y;
			var u1:Number = uvsRect.width + u0;
			var v1:Number = uvsRect.height + v0;
			
			// vertex position.
			w += x;
			h += y;
			if ( transform ) {
				var rx:Number = transform.a;
				var ry:Number = transform.b;
				var ux:Number = transform.c;
				var uy:Number = transform.d;
				var tx:Number = transform.tx;
				var ty:Number = transform.ty;
				var vx:Number;
				var vy:Number;
				index = _quads * size * 16
				vx = x * rx + y * ux + tx;
				vy = x * ry + y * uy + ty;
				sf32( vx, index );
				sf32( vy, index + 4 );
				sf32( u0, index + 8 );
				sf32( v0, index + 12 );
				index += size * 4;
				vx = w * rx + y * ux + tx;
				vy = w * ry + y * uy + ty;
				sf32( vx, index );
				sf32( vy, index + 4 );
				sf32( u1, index + 8 );
				sf32( v0, index + 12 );
				index += size * 4;
				vx = x * rx + h * ux + tx;
				vy = x * ry + h * uy + ty;
				sf32( vx, index );
				sf32( vy, index + 4 );
				sf32( u0, index + 8 );
				sf32( v1, index + 12 );
				index += size * 4;
				vx = w * rx + h * ux + tx;
				vy = w * ry + h * uy + ty;
				sf32( vx, index );
				sf32( vy, index + 4 );
				sf32( u1, index + 8 );
				sf32( v1, index + 12 );
			} else {
				sf32( x, index );
				sf32( y, index + 4 );
				sf32( u0, index + 8 );
				sf32( v0, index + 12 );
				index += size * 4;
				sf32( w, index );
				sf32( y, index + 4 );
				sf32( u1, index + 8 );
				sf32( v0, index + 12 );
				index += size * 4;
				sf32( x, index );
				sf32( h, index + 4 );
				sf32( u0, index + 8 );
				sf32( v1, index + 12 );
				index += size * 4;
				sf32( w, index );
				sf32( h, index + 4 );
				sf32( u1, index + 8 );
				sf32( v1, index + 12 );
			}
			
			if ( _vertexColors ) {
				var offset:Number = _surface.offset[Surface3D.COLOR0] * 4;
				index = _quads * size * 16 + offset;
				sf32( _red, index );
				sf32( _green, index + 4 );
				sf32( _blue, index + 8 );
				sf32( _alpha, index + 12 );
				index += size * 4;
				sf32( _red, index );
				sf32( _green, index + 4 );
				sf32( _blue, index + 8 );
				sf32( _alpha, index + 12 );
				index += size * 4;
				sf32( _red, index );
				sf32( _green, index + 4 );
				sf32( _blue, index + 8 );
				sf32( _alpha, index + 12 );
				index += size * 4;
				sf32( _red, index );
				sf32( _green, index + 4 );
				sf32( _blue, index + 8 );
				sf32( _alpha, index + 12 );
			}
			
			_quads++;
		}
		
		public function drawText( font:TextureFont2D, text:String, x:Number = 0, y:Number = 0, align:int = 0, transform:Matrix = null ):void 
		{
			var cursorX:Number = 0;
			var cursorY:Number = 0;
			var length:int = text.length;
			var index:int = 0;
			var i:int = 0;
			
			cursorX += font.outline;
			cursorY += font.outline;
			
			if ( align & Text2D.CENTER_X ) 
				cursorX -= font.getTextWidth( text, 0, true ) * 0.5 - font.outline * 0.5;
			else if ( align & Text2D.RIGHT ) 
				cursorX -= font.getTextWidth( text, 0, true ) - font.outline * 0.5;
				
			if ( align & Text2D.CENTER_Y ) cursorY -= font.getNumLines( text ) * font.lineHeight * 0.5 - font.outline * 0.5;
			
			while ( i < length ) {
				
				var id:int = text.charCodeAt(i);
				var ch:TextureFontChar = font.chars[id];
				
				// next line.
				if ( id == 10 ) {
					cursorX = font.outline;
					cursorY += font.lineHeight;
					if ( align & Text2D.CENTER_X ) 
						cursorX -= font.getTextWidth( text, i + 1, true ) * 0.5;
					else if ( align & Text2D.RIGHT )
						cursorX -= font.getTextWidth( text, i + 1, true );
				}
				
				// setup char uv's and position..
				if ( ch ) {
					uvs.x = ch.x / font.fontWidth;
					uvs.y = ch.y / font.fontHeight;
					uvs.width = ch.width / font.fontWidth + 1 / font.fontWidth;
					uvs.height = ch.height / font.fontHeight + 1 / font.fontHeight;
					drawImage( x + cursorX + ch.xOffset, y + cursorY + ch.yOffset, ch.width, ch.height, uvs, transform );
					cursorX += ch.xAdvance + font.outline;
				}
				
				i++;
			}
		}
		
		private function setupFrame():void
		{
			// step frame.
			if ( viewPort ) {
				if ( Device3D.viewPort.width / Device3D.viewPort.height > viewPort.width / viewPort.height )
					_camera.fovMode = Camera3D.FOV_VERTICAL;
				else
					_camera.fovMode = Camera3D.FOV_HORIZONTAL;
			}
			
			_camera.updateProjectionMatrix();
			
			var view:Rectangle = viewPort || Device3D.viewPort;
			var vw:Number = view.width;
			var vh:Number = view.height;
			var sw:Number = Device3D.viewPort.width
			var sh:Number = Device3D.viewPort.height;
			var z:Number = 0.5 / _camera.zoom;
			if ( _camera.fovMode == Camera3D.FOV_HORIZONTAL )
				z *= vw;
			else 
				z *= vh;
			
			Device3D.worldViewProj.identity();
			Device3D.worldViewProj.appendTranslation( -vw * 0.5, -vh * 0.5, z );
			Device3D.worldViewProj.appendScale( 1, -1, 1 );
			Device3D.worldViewProj.append( _camera.viewProjection );
			
			transform.identity();
			if ( viewPort ) {
				var w:Number = vw;
				var h:Number = vh;
				var r:Number = sw / vw;
				w *= r;
				h *= r;
				if ( sh < h ) {
					r = sh / h;
					w *= r;
					h *= r;
				}
				transform.translate( -vw * 0.5, -vh * 0.5 );
				transform.scale( w / vw, h / vh );
				transform.translate( sw * 0.5, sh * 0.5 );
			}
			
			ApplicationDomain.currentDomain.domainMemory = _surface.vertexBytes;
		}
		
		public function render():void
		{
			if ( !_quads ) return;
			
			if ( _reupload ) {
				_reupload = false;
				_surface.updateVertexBuffer( 0, _quads * 4 );
				_surface.updateIndexBuffer( 0, _quads * 6 );
			}
			
			if ( !_material ) {
				_defaultMaterial.setTechnique( _vertexColors ? "tinted" : "normal" );
				_defaultMaterial.params.texture.value = _texture;
				_defaultMaterial.draw( null, _surface, 0, _quads * 2 );
			} else
				_material.draw( null, _surface, 0, _quads * 2 );
		}
	}
}