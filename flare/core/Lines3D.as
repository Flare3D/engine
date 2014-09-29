// ================================================================================
//	Copyright 2009 - 2014 Flare3D, Inc.
//	All Rights Reserved.
// ================================================================================

package flare.core 
{
	import flare.basic.*;
	import flare.materials.*;
	import flare.flsl.*;
	import flare.system.*;
	import flare.utils.*;
	import flash.display3D.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	/**
	 * The Lines3D class is a helper to work with 3D pixel thickness lines.
	 */
	public class Lines3D extends Mesh3D
	{
		[Embed(source="shaders/lines.flsl.compiled", mimeType="application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		private var _thickness:Number = 1;
		private var _color:uint = 0xffffff;
		private var _alpha:Number = 1;		
		private var _lx:Number = 0;
		private var _ly:Number = 0;
		private var _lz:Number = 0;
		private var _r:Number = 1;
		private var _g:Number = 1;
		private var _b:Number = 1;
		private var _surf:Surface3D;
		private var _uploaded:Boolean = false;
		private var _lastSize:uint;
		private var _material:FLSLMaterial;
		private var _colors:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>;
		
		public function Lines3D( name:String = "lines" ) 
		{
			super( name );
			
			_material = new FLSLMaterial( "material_lines", data, "lines" );
		}
		
		/** @private */
		override public function clone():Pivot3D 
		{
			var l:Lines3D = new Lines3D( name );
			l.copyFrom( this );
			l.useHandCursor = useHandCursor;
			l.surfaces = surfaces;
			l.bounds = bounds;
			l._colors = _colors;
			l._material = _material;
			
			for each ( var c:Pivot3D in children )
				if ( !c.lock )
					l.addChild( c.clone() );
			
			return l;
		}
		
		/** @private */
		override public function dispose():void 
		{
			download();
			
			super.dispose();
		}
		
		/** @private */
		override public function download( includeChildren:Boolean = true ):void 
		{
			super.download( includeChildren );
			
			_uploaded = false;
		}
		
		/** @private */
		override public function upload( scene:Scene3D, includeChildren:Boolean = true ):void
		{
			super.upload( scene, includeChildren );
			
			if ( scene.context ) contextEvent();
			
			scene.addEventListener( Event.CONTEXT3D_CREATE, contextEvent );
		}
		
		private function contextEvent( e:Event = null ):void 
		{
			for each ( var s:Surface3D in surfaces ) s.upload( scene );
			
			_uploaded = true;
		}
		
		public function clear():void
		{
			for each ( var s:Surface3D in surfaces ) s.download();
			
			surfaces = new Vector.<Surface3D>();
			
			_surf = null;
			_uploaded = false;
			_lx = 0;
			_ly = 0;
			_lz = 0;
		}
		
		public function lineStyle( thickness:Number = 1, color:uint = 0xffffff, alpha:Number = 1 ):void
		{
			_alpha = alpha;
			_color = color;
			_thickness = thickness;
			_r = ( ( color >> 16 ) & 0xff ) / 255;
			_g = ( ( color >> 8 ) & 0xff ) / 255;
			_b = ( color & 0xff ) / 255; 
			_surf = null;
		}
		
		public function moveTo( x:Number, y:Number, z:Number ):void
		{
			_lx = x;
			_ly = y;
			_lz = z;			
		}
		
		public function lineTo( x:Number, y:Number, z:Number ):void
		{
			var index:uint = _surf ? _surf.vertexVector.length / _surf.sizePerVertex : 0;
			
			if ( !_surf || index >= 0x10000 - 6 ) 
			{
				_surf = new Surface3D( name + "_surface" );
				_surf.addVertexData( 0, 3 );
				_surf.addVertexData( 1, 3 );
				_surf.addVertexData( 2, 1 );
				_surf.vertexVector = new Vector.<Number>();
				_surf.indexVector = new Vector.<uint>();
				_colors[ surfaces.length ] = Vector.<Number>( [_r, _g, _b, _alpha] );
				surfaces.push( _surf );
				index = 0;
			}
			
			_surf.vertexVector.push( _lx, _ly, _lz, x, y, z, _thickness,
									   x, y, z, _lx, _ly, _lz, -_thickness,
									 _lx, _ly, _lz, x, y, z, -_thickness,
									   x, y, z, _lx, _ly, _lz, _thickness
									);
			_surf.indexVector.push( index + 2, index + 1, index, index + 1, index + 2, index + 3 );
			
			_lx = x;
			_ly = y;
			_lz = z;
			
			_uploaded = false;
		}
		
		public function setColor( r:Number, g:Number, b:Number, a:Number = 1 ):void
		{
			for ( var i:int = 0; i < surfaces.length; i++ )
				_colors[ i ] = Vector.<Number>( [r, g, b, a] );			
		}
		
		/** @private */
		override public function draw( includeChildren:Boolean = true, material:Material3D = null ):void 
		{
			if ( !scene ) upload( Device3D.scene );
			
			if ( _eventFlags & ENTER_DRAW_FLAG ) dispatchEvent( _enterDrawEvent );
			
			if ( inView ) 
			{
				if ( !_uploaded ) 
				{
					for each ( var surf:Surface3D in surfaces ) surf.download();
					
					_uploaded = true;
				}			
				
				Device3D.global.copyFrom( world );
				Device3D.worldViewProj.copyFrom( _world );
				Device3D.worldViewProj.append( Device3D.viewProj );
				Device3D.objectsDrawn++;
				
				if ( !_material || !_material.scene ) upload( scene );
				
				if ( Device3D.camera.fovMode == Camera3D.FOV_HORIZONTAL )
					_material.params.size.value[0] = Device3D.camera.zoom / Device3D.viewPort.width;
				else
					_material.params.size.value[0] = Device3D.camera.zoom / Device3D.viewPort.height;
				
				for ( var i:int = 0; i < surfaces.length; i++ ) 
				{
					_material.params.color.value = _colors[i];
					_material.draw( this, surfaces[i] );
				}
			}
			
			if ( includeChildren ) 
				for each ( var child:Pivot3D in children ) child.draw( includeChildren )
			
			if ( _eventFlags & EXIT_DRAW_FLAG ) dispatchEvent( _exitDrawEvent );
		}
		
		public function get material():FLSLMaterial 
		{
			return _material;
		}
	}
}