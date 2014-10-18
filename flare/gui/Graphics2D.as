package flare.gui
{
	import flare.core.*;
	import flare.flsl.*;
	import flare.system.*;
	import flare.utils.*;
	import flash.display3D.*;
	import flash.geom.*;
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
		private static var material:FLSLMaterial;
		
		/**
		 * Sets a fixed area in pixels to draw. If the area is bigger or smaller than the screen viewport, it will scale to adapt to 
		 * cover the entire screen size while keeping the aspect ractio.
		 */
		public var viewPort:Rectangle;
		public var transform:Matrix = new Matrix;
		
		private var _reupload:Boolean = true;
		private var _camera:Camera3D = new Camera3D();
		private var _surface:Surface3D;
		private var _vertices:int = 0;
		private var _quadsTotal:int = 0;
		private var _quadCount:int = 0;
		private var _material:FLSLMaterial;
		private var _texture:Texture3D;
		private var _dirty:Boolean = true;
		private var _red:Number = 1;
		private var _green:Number = 1;
		private var _blue:Number = 1;
		private var _alpha:Number = 1;
		
		private var _vertexVector:Vector.<Number> = new Vector.<Number>;
		private var _indexVector:Vector.<uint> = new Vector.<uint>;
		
		public function Graphics2D() 
		{
			if ( !material ) 
				material = new FLSLMaterial( "gui", new GUI_FLSL, null, true );
				
			_surface = new Surface3D( "spriteQuads" );
			_surface.addVertexData( Surface3D.POSITION, 2 );
			_surface.addVertexData( Surface3D.UV0, 2 );
			_surface.addVertexData( Surface3D.COLOR0, 4 );
			_surface.vertexVector = _vertexVector;
			_surface.indexVector = _indexVector;
		}
		
		private function expand( quads:int = -1 ):void
		{
			if ( quads == -1 ) {
				quads = _quadsTotal * 2;
				if ( quads == 0 ) quads = 1;
			}
			
			_surface.vertexVector.fixed = false;
			_surface.vertexVector.length += quads * 4 * _surface.sizePerVertex;
			_surface.vertexVector.fixed = true;
			_surface.download();
			
			var index:Vector.<uint> = _surface.indexVector;
			for ( var i:int = 0; i < quads; i++ ) {
				index.push( _vertices, _vertices + 1, _vertices + 2, _vertices + 3, _vertices + 2, _vertices + 1 );
				_vertices += 4;
			}
		}
		
		private function reset():void
		{
			_red = 1;
			_green = 1;
			_blue = 1;
			_alpha = 0.2;
			_quadCount = 0;
			_quadsTotal = 0;
			_texture = null;
			_material = null;
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
			
			_dirty = true;
		}
		
		public function setScrollRect( rect:Rectangle ):void
		{
			flush();
			
			Device3D.context.setScissorRectangle( rect );
		}
		
		public function beginShaderFill( material:FLSLMaterial ):void
		{
			if ( _material != material )
				flush();
			
			_material = material;
		}
		
		public function beginTextureFill( texture:Texture3D, tint:Vector3D = null ):void
		{
			if ( _material != material || _texture != texture )
				flush();
			
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
			_material = material;
		}
		
		public function drawFrame( x:Number, y:Number, frame:TextureFrame, transform:Matrix = null ):void
		{
			drawImage( x, y, frame.width, frame.height, frame.uv, transform );
		}
		
		public function drawImage( x:Number, y:Number, w:Number, h:Number, uvsRect:Rectangle = null, transform:Matrix = null ):void
		{
			if ( _vertices <= _quadsTotal * 4 ) 
				expand();
			else
				_reupload = true;
			
			var vertex:Vector.<Number> = _surface.vertexVector;
			var index:int = _quadsTotal * 32;
			
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
				vx = x * rx + y * ux + tx;
				vy = x * ry + y * uy + ty;
				vertex[index++] = vx;
				vertex[index++] = vy;
				vertex[index++] = u0;
				vertex[index++] = v0;
				vertex[index++] = _red;
				vertex[index++] = _green;
				vertex[index++] = _blue;
				vertex[index++] = _alpha;
				vx = w * rx + y * ux + tx;
				vy = w * ry + y * uy + ty;
				vertex[index++] = vx;
				vertex[index++] = vy;
				vertex[index++] = u1;
				vertex[index++] = v0;
				vertex[index++] = _red;
				vertex[index++] = _green;
				vertex[index++] = _blue;
				vertex[index++] = _alpha;
				vx = x * rx + h * ux + tx;
				vy = x * ry + h * uy + ty;
				vertex[index++] = vx;
				vertex[index++] = vy;
				vertex[index++] = u0;
				vertex[index++] = v1;
				vertex[index++] = _red;
				vertex[index++] = _green;
				vertex[index++] = _blue;
				vertex[index++] = _alpha;
				vx = w * rx + h * ux + tx;
				vy = w * ry + h * uy + ty;
				vertex[index++] = vx;
				vertex[index++] = vy;
				vertex[index++] = u1;
				vertex[index++] = v1;
				vertex[index++] = _red;
				vertex[index++] = _green;
				vertex[index++] = _blue;
				vertex[index++] = _alpha;
			} else {
				vertex[index++] = x;
				vertex[index++] = y;
				vertex[index++] = u0;
				vertex[index++] = v0;
				vertex[index++] = _red;
				vertex[index++] = _green;
				vertex[index++] = _blue;
				vertex[index++] = _alpha;
				vertex[index++] = w;
				vertex[index++] = y;
				vertex[index++] = u1;
				vertex[index++] = v0;
				vertex[index++] = _red;
				vertex[index++] = _green;
				vertex[index++] = _blue;
				vertex[index++] = _alpha;
				vertex[index++] = x;
				vertex[index++] = h;
				vertex[index++] = u0;
				vertex[index++] = v1;
				vertex[index++] = _red;
				vertex[index++] = _green;
				vertex[index++] = _blue;
				vertex[index++] = _alpha;
				vertex[index++] = w;
				vertex[index++] = h;
				vertex[index++] = u1;
				vertex[index++] = v1;
				vertex[index++] = _red;
				vertex[index++] = _green;
				vertex[index++] = _blue;
				vertex[index++] = _alpha;
			}
			
			_quadsTotal++;
			_quadCount += 2;
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
		}
		
		public function render():void
		{
			if ( !_quadCount || !_material ) return;
			
			if ( !_material.scene ) 
				_material.upload( Device3D.scene );
			
			if ( _reupload ) {
				_reupload = false;
				_surface.updateVertexBuffer();
				_surface.updateIndexBuffer();
			}
			
			if ( _dirty ) setupFrame();
			
			_dirty = false;
			
			material.setTechnique( "normal" );
			material.params.texture.value = _texture;
			
			_material.draw( null, _surface, 0, _quadCount );
		}
	}
}