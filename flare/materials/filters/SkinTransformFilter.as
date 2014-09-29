package flare.materials.filters 
{
	import flare.flsl.*;
	import flare.materials.*;
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class SkinTransformFilter extends FLSLFilter 
	{
		private var _bones:int;
		
		public function SkinTransformFilter( bones:int = 1 ) 
		{
			_bones = bones;
			
			super( null, null, "flare.transforms.skin" + bones );
		}
		
		override public function init( material:Material3D, index:int, pass:int ):void 
		{
			super.init( material, index, pass );
			
			if ( _bones == 1 ) material.flags = 1;
			if ( _bones == 2 ) material.flags = 2;
			if ( _bones == 3 ) material.flags = 4;
			if ( _bones == 4 ) material.flags = 8;
		}
		
		override public function process( scope:FLSLShader ):void
		{
			scope.outputVertex = scope.call( techniqueName );
		}
	}
}