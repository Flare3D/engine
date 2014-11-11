package flare.gui
{
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Pivot2D extends EventDispatcher
	{
		internal static const TO_RAD:Number = Math.PI / 180;
		internal static const TWO_PI:Number = Math.PI * 2;
		internal static const POW:Number = Math.pow( 10, 3 );
		internal static const cos:Vector.<Number> = new Vector.<Number>;
		internal static const sin:Vector.<Number> = new Vector.<Number>;
		internal static var inv:Matrix = new Matrix;
		
		/** 
		 * Defines the value for the 'added' event. 
		 */
		public static const ADDED_EVENT:String = "added";
		/** 
		 * Defines the value for the 'removed' event. 
		 */
		public static const REMOVED_EVENT:String = "removed";
		
		public var name:String;
		public var x:Number = 0;
		public var y:Number = 0;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var width:Number = 0;
		public var height:Number = 0;
		public var transform:Matrix = new Matrix;
		public var children:Vector.<Pivot2D>;
		public var graphics:Graphics2D;
		public var rotation:Number = 0;
		public var mouseEnabled:Boolean = false;
		public var mouseRect:Rectangle;
		public var visible:Boolean = true;
		/**
		 * Sets a tint value for this object. It affects, red, green, blue and alpha values.
		 */
		public var tint:Vector3D;
		/**
		 * Sets the center of rotation and scale point for this object.
		 * This property does not affect position, wich is always in local space coordinates.
		 */
		public var center:Point;
		
		private var _parent:Pivot2D;
		
		public function Pivot2D( name:String = "" ) 
		{
			if ( cos.length == 0 ) {
				var round:Number = 1.0 / POW;
				var len:uint = 1 + Math.PI * 2 * POW;
				cos.length = len; cos.fixed = true;
				sin.length = len; sin.fixed = true;
				var theta:Number = 0;
				for ( var i:uint = 0; i < len; ++i ) {
					cos[i] = Math.cos(theta);
					sin[i] = Math.sin(theta);
					theta += round;
				}
				trace(len);
			}
			
			this.name = name;
		}
		
		public function getChildByName( name:String, startIndex:int = 0, includeChildren:Boolean = true ):Pivot2D
		{
			if ( children ) {
				var length:int = children.length;
				for ( var i:int = 0; i < length; i++ )
					if ( children[i].name == name && --startIndex < 0 ) return children[i];
			}
			
			if ( includeChildren ) {
				for ( i = 0; i < length; i++ ) {
					var child:Pivot2D  = children[i].getChildByName( name, startIndex, includeChildren )
					if ( child ) return child				
				}
			}
			
			return null
		}
		
		public function addChildAt( pivot:Pivot2D, index:int ):Pivot2D
		{
			if ( !children ) children = new Vector.<Pivot2D>;
			addChild( pivot );
			children.splice( children.indexOf( pivot ), 1 );
			children.splice( index, 0, pivot );
			return pivot;
		}
		
		public function addChild( pivot:Pivot2D ):Pivot2D
		{
			if ( pivot.parent == this ) return pivot
			
			pivot.parent = this;
			
			return pivot;
		}
		
		public function removeChild( pivot:Pivot2D ):Pivot2D
		{
			pivot.parent = null		
			
			return pivot
		}
		
		public function get parent():Pivot2D { return _parent; }
		
		public function set parent( pivot:Pivot2D ):void 
		{
			if ( pivot == _parent ) return;
			
			if ( _parent ) 
			{
				var index:int = _parent.children.indexOf( this );
				
				if ( index != -1 )
				{
					_parent.children.splice( index, 1 );
					
					graphics = null;
					dispatchEvent( new Event( REMOVED_EVENT ) );
				}
			}
			
			_parent = pivot;
			
			if ( pivot ) 
			{
				setGraphics( pivot.graphics );
				if ( !pivot.children ) pivot.children = new Vector.<Pivot2D>;
				pivot.children.push( this ); 
				dispatchEvent( new Event( ADDED_EVENT ) );
			}
		}
		
		private function setGraphics( graphics:Graphics2D ):void
		{
			this.graphics = graphics;
			for each ( var p:Pivot2D in children )
				p.setGraphics( graphics );
		}
		
		[Inline] final internal function updateTransform():void
		{
			transform.tx = x;
			transform.ty = y;
			
			if ( rotation == 0 ) {
				transform.a = scaleX;
				transform.b = 0;
				transform.c = 0;
				transform.d = scaleY;
				if ( center ) {
					transform.tx -= center.x * scaleX;
					transform.ty -= center.y * scaleY
				}
			} else {
				var r:Number = (rotation * TO_RAD) % TWO_PI;
				if ( r < 0 ) r += TWO_PI;
				const idx:uint = r * POW;
				const c:Number = cos[idx];
				const s:Number = sin[idx];
				transform.a = c * scaleX;
				transform.b = s * scaleX;
				transform.c = -s * scaleY;
				transform.d = c * scaleY;
				if ( center ) {
					transform.tx -= center.x * transform.a + center.y * transform.c;
					transform.ty -= center.x * transform.b + center.y * transform.d;
				}
			}
			
			if ( _parent && _parent.transform )
				transform.concat( _parent.transform );
		}
		
		public function updateTransforms( includeChildren:Boolean = false ):void
		{
			if ( transform ) updateTransform();
			
			if ( includeChildren && children ) {
				var l:int = children.length;
				for ( var i:int = 0; i < l; i++ ) 
					children[i].updateTransforms( includeChildren );
			}
		}
		
		public function testPoint( x:Number, y:Number, includeChildren:Boolean = true ):Pivot2D
		{
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
				if ( !mouseRect ) {
					if ( vx > 0 && vy > 0 && vx < width && vy < height ) return this;
				} else {
					if ( vx > mouseRect.x && vy > mouseRect.y && vx < mouseRect.right && vy < mouseRect.bottom ) return this;
				}
			}
			
			return null;
		}
		
		public function draw():void
		{
			if ( !graphics || !visible ) return;
			
			if ( transform ) updateTransform();
			
			if ( children ) {
				var length:int = children.length;
				for ( var i:int = 0; i < length; i++ ) children[i].draw()
			}
		}
		
		override public function toString():String 
		{
			var cname:String = getQualifiedClassName(this);
			cname = cname.substr( cname.indexOf( "::" ) + 2 );
			return "[object " + cname + " name:" + name + "]";
		}
	}
}