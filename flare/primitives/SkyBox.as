// ================================================================================
//	Copyright 2009 - 2014 Flare3D, Inc.
//	All Rights Reserved.
// ================================================================================

package flare.primitives 
{
	import flare.basic.*;
	import flare.core.*;
	import flare.flsl.*;
	import flare.materials.*;
	import flare.materials.filters.*;
	import flare.system.*;
	import flash.display.*;
	import flash.display3D.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	/**
	 * Creates a new skyBox.
	 * 
	 * @author Ariel Nehmad
	 */
	public class SkyBox extends Sphere 
	{
		[Embed(source = "skybox.flsl.compiled", mimeType = "application/octet-stream")]
		private static var data:Class;
		
		private var _texture:Texture3D;
		private var _scaleRatio:Number;
		private var _material:FLSLMaterial;
		
		/**
		 * Creates a new SkyBox object.
		 * @param	request Any of the values accepted in Texture3D.
		 * @param	sceneContext The context library from where the images will be loaded. If not context is specified, the SkyBox will manage to load the images internally and will return progress and complete events.
		 * @param	scaleRatio The scale ratio that defines the proyection scale.
		 */
		public function SkyBox( request:*, sceneContext:Scene3D = null, scaleRatio:Number = 0.5 ) 
		{
			_texture = new Texture3D( request, false, Texture3D.FORMAT_RGBA, Texture3D.TYPE_CUBE );
			_texture.mipMode = Texture3D.MIP_NONE;
			_texture.wrapMode = Texture3D.WRAP_CLAMP;
			
			if ( sceneContext ) sceneContext.library.push( _texture );
			
			_scaleRatio = scaleRatio;
			_material = new FLSLMaterial( "skybox", new data );
			_material.params.texture.value = _texture;
			
			super( "skybox", 5, 24, _material );
			
			setLayer( 32 );
			castShadows = false;
			receiveShadows = false;
		}
		
		/** @private */
		override public function get inView():Boolean 
		{
			return true;
		}
		
		/** @private */
		override public function draw(includeChildren:Boolean = true, material:Material3D = null ):void 
		{
			if ( !visible ) return;
			
			if ( !scene ) upload( Device3D.scene );
			
			Device3D.global.copyFrom( world );
			Device3D.worldViewProj.copyFrom( world );
			Device3D.worldViewProj.append( Device3D.viewProj );
			Device3D.worldViewProj.appendScale( _scaleRatio, _scaleRatio, 1 )
			Device3D.objectsDrawn++;
			Device3D.lastMaterial = null;
			
			_material.draw( this, surfaces[0] );
		}
		
		
		public function get scaleRatio():Number 
		{
			return _scaleRatio;
		}
		
		/**
		 * The scale ratio that defines the proyection scale.
		 */
		public function set scaleRatio(value:Number):void 
		{
			_scaleRatio = value;
		}
	}
}