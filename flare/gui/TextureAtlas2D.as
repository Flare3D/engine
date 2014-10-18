package flare.gui
{
	import flare.core.*;
	import flash.geom.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class TextureAtlas2D extends Texture3D
	{
		private var _index:Object = {};
		private var _frames:Vector.<TextureFrame> = new Vector.<TextureFrame>;
		
		public function TextureAtlas2D( request:*, xml:XML ) 
		{
			mipMode = MIP_NONE;
			wrapMode = WRAP_CLAMP;
			
			super( request );
			
			name = xml.@imagePath;
			
			var w:Number = xml.@width;
			var h:Number = xml.@height;
			for each ( var x:XML in xml.sprite ) {
				var f:TextureFrame = new TextureFrame;
				f.x = x.@x;
				f.y = x.@y;
				f.width = x.@w;
				f.height = x.@h;
				f.uv.x = x.@x / w;
				f.uv.y = x.@y / h;
				f.uv.width = x.@w / w;
				f.uv.height = x.@h / h;
				f.offset.x = x.@oX || 0;
				f.offset.y = x.@oY || 0;
				f.offset.width = x.@oW || x.@w;
				f.offset.height = x.@oH || x.@h;
				f.name = x.@n;
				_index[f.name] = _frames.length;
				_frames.push( f );
			}
		}
		
		public function getFrame( name:String ):TextureFrame
		{
			var index:int = _index[name];
			
			return _frames[index];
		}
	}
}