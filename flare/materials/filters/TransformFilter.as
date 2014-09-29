package flare.materials.filters 
{
	import flare.flsl.*;
	import flash.display.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class TransformFilter extends FLSLFilter 
	{
		public function TransformFilter()
		{
			super( null, null, "flare.transforms.transform" );
		}
		
		override public function process( scope:FLSLShader ):void
		{
			scope.outputVertex = scope.call( techniqueName );
		}
	}
}