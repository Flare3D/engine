package flare.gui
{
	/**
	 * @author Ariel Nehmad
	 */
	public class TextureFontChar 
	{
		public var id:int;
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var xOffset:Number;
		public var yOffset:Number;
		public var xAdvance:Number;
		public var page:uint;
		
		public function TextureFontChar( xml:XML ) 
		{
			this.id = xml.@id;
			this.x = xml.@x;
			this.y = xml.@y;
			this.width = xml.@width;
			this.height = xml.@height;
			this.xOffset = xml.@xoffset;
			this.yOffset = xml.@yoffset;
			this.xAdvance = xml.@xadvance;
			this.page = xml.@page;
		}
	}
}