
package com.blit
{
	import com.blit.core.BitmapDataCollection;
	import com.blit.core.Camera2D;
	
	/**
	 * The Globals class contains global properties and settings.
	 */
	public final class Globals
	{
		/**
		 * @see Camera2D
		 */
		public static var camera2D:Camera2D = Camera2D.getInstance();
		/**
		 * @see BitmapDataCollection
		 */
		public static var bmdCollection:BitmapDataCollection = BitmapDataCollection.getInstance();
			
	}
}

