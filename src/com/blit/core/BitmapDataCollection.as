
package com.blit.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * The BitmapDataCollection class creates a collection object that stores and manages all BitmapData objects.
	 * 
	 * The methods of this class can be used to enforce that no duplicate BitmapData objects will be created. 
	 * This class is used internally to ensure that no matter how many instances of a renderable object 
	 * exist there will be only one BitmapData object.
	 * 
	 */
	
	public final class BitmapDataCollection
	{
		/**
		 * @public 
		 */		
		private static var mInstance:BitmapDataCollection;
		
		private static var mIsAllowInstance:Boolean;
		
		/**
		 * The object that stores the BitmapData objects 
		 */		
		public var mBmpDataCollection:Object = {};
		
		public function BitmapDataCollection()
		{
			// singleton
			if( !mIsAllowInstance )
			{
				throw new Error( "BitmapDataCollection is a singleton. " + 
					"Use the getInstance method to create an instance."
				);
			}
		}
		
		/**
		 * Creates the singleton BitmapDataCollection instance.
		 * 
		 * @return The singleton instance of BitmapDataCollection. 
		 */
		public static function getInstance():BitmapDataCollection
		{
			if(!mInstance)
			{
				mIsAllowInstance = true;
				mInstance = new BitmapDataCollection();
				mIsAllowInstance = false;
			}
			
			return mInstance;
		}
		
		/**
		 * Adds a BitmapData object to the collection with the supplied String identifier.
		 * 
		 * @param id The unique identifier to assign to the BitmapData object once added to the collection.
		 * @param bitmapData The BitmapData object to add to the collection.
		 * @return A reference to the BitmapData object within the collection.
		 */
		public function addBitmapData(id:String, bmpData:BitmapData):BitmapData
		{
			mBmpDataCollection[id] = bmpData;
			return mBmpDataCollection[id];
		}
		
		/**
		 * Searches the collection for the supplied String identifier.
		 * 
		 * @param item The String identifier to search for within the collection.
		 * @return A boolean value indicating if the item exists within the collection.
		 */
		public function lookup(item:String):Boolean
		{
			var value:Boolean = false;
			
			if( mBmpDataCollection[item] )
			{
				value = true;
			}
			
			return value;
		}
		
		/**
		 * Removes all BitmapData objects within the collection.
		 * 
		 * Note: Every BitmapData object becomes <code>null</code> once removed and is no longer available in memory.
		 * 
		 */
		public function disposeAll():void
		{
			var item:BitmapData;
			
			for each(item in mBmpDataCollection)
			{
				item.dispose();
				item = null;
			}
			
			mBmpDataCollection = {};
		}
		
		/**
		 * Removes the suplied BitmapData object from the collection.
		 * 
		 * Note: The BitmapData object becomes <code>null</code> once removed and is no longer available in memory.
		 * 
		 * @param id The String identifier within the collection
		 * @return A boolean value indicating if the BitmapData object was removed from the collection.
		 */		
		public function removeBitmapData( id:String):Boolean
		{
			var value:Boolean = false;
			
			if( lookup(id) )
			{
				var bmpData:BitmapData = mBmpDataCollection[id] as BitmapData;
				bmpData.dispose();
				bmpData = null;
				
				value = true;
			}
			
			// cannot remove the bitmdpdata object
			return value;
		}
		
		public function getCollection(id:String):Object
		{
			return mBmpDataCollection[id];
		}
	}
}

