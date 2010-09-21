
package com.blit.core
{
	import com.blit.Globals;
	import com.blit.layers.IRenderLayer;
	import com.blit.layers.RenderLayer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Manager class for all the RenderLayers 
	 * @author arpannanavati
	 * 
	 */	
	public class Render2D extends Bitmap
	{
		private var mLayers:Vector.<RenderLayer>;
		private var mLayerLength:int;  
		private var mRect:Rectangle;		
		
		private var mHasBg:Boolean = false;
		
		private const ZERO_POINT:Point = new Point();
		
		public function Render2D( width:int, height:int )
		{
			mLayers = new Vector.<RenderLayer>();
			bitmapData = new BitmapData( width, height);
			mRect = bitmapData.rect;
		}
		
		public function addChild(layer:RenderLayer):void
		{
			mLayers.push(layer);
			layer.renderer = this;
			layer.setSize( bitmapData.width, bitmapData.height );
		}
		
		public function removeLayer(layer:RenderLayer):Boolean
		{
			var returnValue:Boolean = false;
			var i:int = 0;
			
			for each(layer in mLayers)
			{
				if(mLayers[i] == layer)
				{
					mLayers.splice(i, 1);
					returnValue = true;
				}
				i++;
			}
			
			return returnValue;
		}
		
		public function swapLayers( layer1:IRenderLayer, layer2:IRenderLayer):void
		{
			var idx1:int = mLayers.indexOf(layer1);
			var idx2:int = mLayers.indexOf(layer2);
			
			// swap
			mLayers[idx1] = layer2 as RenderLayer;
			mLayers[idx2] = layer1 as RenderLayer;
		}
		
		public function render():void
		{
			Globals.camera2D.scroll();
			
			bitmapData.lock();
			
			if(!mHasBg)
			{
				bitmapData.fillRect(mRect, 0x0);
			}
			
			var layer:RenderLayer;
			
			for each(layer in mLayers)
			{
				layer.render();
				bitmapData.copyPixels(layer.bitmapData, mRect, ZERO_POINT, null, null, true);
			}
			
			bitmapData.unlock();
		}
		
		// getter and setter
		
		public function get numLayers():int
		{
			return mLayers.length;	
		}
		
		public function getLayerDepth(layer:IRenderLayer):int
		{
			return mLayers.indexOf(layer);
		}
		
		public function set cameraTarget( pt:Point):void
		{
			Globals.camera2D.target = pt;
		}
		
		public function get cameraTarget():Point
		{
			return Globals.camera2D.target;
		}
		
		public function set cameraBoundry( rct:Rectangle):void
		{
			rct.x = bitmapData.width >> 1;
			rct.y = bitmapData.height >> 1;
			
			rct.width -= bitmapData.width;
			rct.height -= bitmapData.height;
			
			Globals.camera2D.boundry = rct;
		}
		
		public function get cameraBoundry():Rectangle
		{
			return Globals.camera2D.boundry;	
		}
		
		public function set cameraEase( value:Number):void
		{
			Globals.camera2D.ease = value;
		}
		
		public function get cameraEase():Number
		{
			return Globals.camera2D.ease;	
		}
		
		public function get hasBG():Boolean
		{
			return mHasBg;
		}
		
		public function set hasBG(value:Boolean):void
		{
			mHasBg = value;
		}
		
	}
}