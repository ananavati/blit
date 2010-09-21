
package com.blit.layers
{
	import com.blit.Globals;
	import com.blit.core.Render2D;
	import com.blit.effects.DefaultEffect;
	import com.blit.effects.FogEffect;
	import com.blit.effects.GlowEffect;
	import com.blit.effects.GridEffect;
	import com.blit.effects.IEffect;
	import com.blit.effects.TrailsEffect;
	import com.blit.elements.PixelSprite;
	import com.blit.layers.IRenderLayer;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class RenderLayer implements IRenderLayer
	{
		private var mItems:Vector.<PixelSprite>;
		private var mPos:Point;
		private var mCamPoint:Point;
		private var mRenderer:Render2D;
		
		private var isUseParallax:Boolean;
		private var isUpdated:Boolean;
		
		private var mWidth:int;
		private var mHeight:int;
		
		public var bitmapData:BitmapData;
		public var mRect:Rectangle;
		
		public var mEffect:IEffect = new DefaultEffect();
		
		public function RenderLayer( useParallax:Boolean = false )
		{
			isUseParallax = useParallax;
			mItems = new Vector.<PixelSprite>();
			mCamPoint = Globals.camera2D.basePoint;
			mPos = new Point();
			isUpdated = true;
		}
		
		public function setSize( width:int, height:int):void
		{
			bitmapData = new BitmapData( width, height, true, 0);
			mRect = bitmapData.rect;
			
			this.mWidth = bitmapData.width;
			this.mHeight = bitmapData.height;
			
			mEffect.init(mRect);
		}
		
		public function addChild(item:PixelSprite):void
		{
			mItems.push(item);
			item.layer = this;
			isUpdated = true;			
		}
		
		public function addChildAt(item:PixelSprite, idx:int):void
		{
			mItems.splice(idx, 0, item);
		}
		
		public function removeChild(item:PixelSprite):Boolean
		{
			var value:Boolean = false;
			var i:int = 0;
			
			for(i=0; i<mItems.length; i++)
			{
				if(item == mItems[i])
				{
					mItems.splice(i, 1);
					value = true;
				}
			}
			
			isUpdated = true;
			
			return value;
		}
		
		public function removeChildAt(item:PixelSprite, idx:int):void
		{
			mItems.splice(idx, 1);
		}
		
		public function swapDepths(item1:PixelSprite, item2:PixelSprite):void
		{
			var idx1:int = mItems.indexOf(item1);
			var idx2:int = mItems.indexOf(item2);
			
			// swap the data
			mItems[idx1] = item2;
			mItems[idx2] = item1;
			
			isUpdated = true;
		}
		
		public function render():void
		{
			if(isUseParallax)
			{
				//
			}
			
			isUpdated = false;
			var redraw:Boolean = false;
			
			// pre-render the rect to apply the effect
			if(mEffect)
			{
				mEffect.preRender( bitmapData );
			}
			else
			{
				bitmapData.fillRect( mRect, 0 );
			}
			
			bitmapData.lock();
			
			var item:PixelSprite;
			
			for each(item in mItems)
			{
				isUpdated = true;
				
				mPos.x = Math.ceil(item.x + mCamPoint.x);
				mPos.y = Math.ceil(item.y + mCamPoint.y);
				
				if( ( mPos.x > -item.width && mPos.x < mWidth + item.width ) && ( mPos.y > -item.height && mPos.y < mHeight + item.height ) )
				{
					item.update();
					bitmapData.copyPixels( item.bitmapData, item.rect, mPos, null, null, true );
				}
			}
			
			bitmapData.unlock();
			
			mEffect.postRender( bitmapData );
		}
		
		public function hasUpdated():Boolean
		{
			return isUpdated;
		}
		
		// getter and setter
		public function get renderer():Render2D
		{
			return mRenderer;	
		}
		
		public function get numChildren():int
		{
			return mItems.length;
		}
		
		public function set renderer(value:Render2D):void
		{
			mRenderer = value;
		}
		
		public function get filter():IEffect
		{
			return mEffect;
		}
		
		public function set filter( value:IEffect ):void
		{
			mEffect = value;
			
			if ( mRenderer )
			{
				mEffect.init( mRect );
			}
		}
		
		public function set rect(value:Rectangle):void
		{
			mRect = value;
		}
		
		public function get rect():Rectangle
		{
			return mRect;
		}
		
		public function getDepth(item:PixelSprite):int
		{
			return mItems.indexOf(item);
		}
	}
}