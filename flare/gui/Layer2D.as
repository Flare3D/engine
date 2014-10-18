package flare.gui
{
	/**
	 * @author Ariel Nehmad
	 */
	public class Layer2D extends Pivot2D
	{
		public function Layer2D( name:String = "" ) 
		{
			super( name );
			
			graphics = new Graphics2D;
		}
		
		override public function draw():void
		{
			if ( !graphics || !visible ) return;
			
			updateTransforms( true );
			
			graphics.clear();
			
			super.draw();
			
			graphics.render();
		}
	}

}