package 
{
	/**
	 * This example bounces 20 PixelSprites around the stage. Click on a PixelSprite and it will be removed.
	 *
	 * This demonstrates several of the basic ingredients in using the PixelBlitz engine: 
	 *		
	 *		create the main renderer, 
	 *		create a renderLayer and add it to the renderer,
	 *		create some PixelSprites and add them to the renderLayer,
	 *		create and apply an effect to a layer,
	 *		check mouse interaction using the getCollisionPoint method
	 *		properly remove PixelSprites and make them available for garbage collection
	 * 		and lastly call the renderer.render() method to render the PixelClips to the screen
	 */
	
	import com.blit.core.Render2D;
	import com.blit.effects.GridEffect;
	import com.blit.effects.TrailsEffect;
	import com.blit.elements.PixelSprite;
	import com.blit.layers.RenderLayer;
	import com.blit.utils.FPSCounter;
	import com.luaye.console.C;
	import com.luaye.console.ConsoleStyle;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	[SWF(width='700', height='640', backgroundColor='#ffffff', frameRate='40')]

	public class main extends Sprite
	{
		private const stageWidth:int 	= stage.stageWidth;
		private const stageHeight:int 	= stage.stageHeight;
		
		private var renderer:Render2D = new Render2D( stageWidth, stageHeight );	// main renderer
		private var layer:RenderLayer 	= new RenderLayer();						// renderLayer to hold the PixelClips
		//private var layer1:RenderLayer 	= new RenderLayer();						// renderLayer to hold the PixelClips
		private var holder:Array 		= [];										// array to hold a reference to all of the PixelClips
		
		//private var mouse:Point = new Point(350, 320);	
		
		[Embed( source="smiley.png" )]
		public static var BoxHead:Class;
		
		[Embed( source="smiley1.png" )]
		public static var SmileHead:Class;
		
		public function main()
		{
			for ( var i:int = 0; i < 20; i++ ) 
			{
				spawn();
			}
			
			C.startOnStage(this, "`");
			C.visible = true; // show console, because having password hides console.
			//C.tracing = true; // trace on flash's normal trace
			C.commandLine = true; // enable command line
			
			C.width = 240;
			C.height = 20;
			C.maxLines = 2000;
			C.fpsMonitor = true;
			C.remoting = true;
			C.displayRoller = true;
			C.remotingPassword = null; // Just so that remote don't ask for password
			
			//renderer.addLayer( layer );												// add the layer to the renderer
			renderer.addChild( layer );
			//renderer.addLayer( layer1 );
			
			stage.addEventListener( Event.ENTER_FRAME, update );
			stage.addEventListener( MouseEvent.MOUSE_DOWN, mouseHandler );
				
			//renderer.cameraTarget 	= mouse;													// set the camera target to the mouse point
			//renderer.cameraBoundry 	= new Rectangle( 0, 0, 4000, 4000 );
			
			addChild( renderer );
			//addChild(new FPSCounter());
		}
				
		private function spawn1():void
		{
			addChild(new BoxHead() as Bitmap);
		}
		
		private function spawn():void
		{
			var ps:PixelSprite = new PixelSprite( new BoxHead() );					// create a new PixelSprite with the library linked symbol BoxHead
			ps.x = stageWidth / 2;													// center on the x axis
			ps.y = stageHeight / 2;													// center on the y axis
			ps.vx = Math.random() * 12 - 6;											// assign a random x velocity
			ps.vy = Math.random() * 12 - 6;											// assign a random y velocity
			
			//ps.bitmapData.applyFilter(ps.bitmapData, new Rectangle(ps.width, ps.height), new Point(), new BlurFilter( 3, 3, 2 ));
			
			var ps1:PixelSprite = new PixelSprite( new SmileHead() );					// create a new PixelSprite with the library linked symbol BoxHead
			ps1.x = stageWidth / 2;													// center on the x axis
			ps1.y = stageHeight / 2;													// center on the y axis
			ps1.vx = Math.random() * 12 - 6;											// assign a random x velocity
			ps1.vy = Math.random() * 12 - 6;											// assign a random y velocity
			
			//layer.filter = new GridEffect();
			layer.addChild( ps);
			holder.push( ps );														// store a reference to the PixelSprite in the holder array
			
			layer.filter = new TrailsEffect();
			layer.addChild(ps1);
			holder.push(ps1);
		}
		
		private function mouseHandler( event:MouseEvent ):void
		{
			for ( var i:int = holder.length - 1; i > -1; i-- )						// loop backwards through the holder array to check the top-most clips first
			{
				var ps:PixelSprite = holder[i];										// reference to each PixelSprite
				if ( ps.getCollisionPoint( new Point( stage.mouseX, stage.mouseY ) ) ) // check if the current mouse position is within a PixelSprite 
				{
					ps.dispose();													// remove the pixelSprite and clear internal data
					holder.splice( i, 1 );											// destroy the reference to the PixelSprite to make it available for garbage collection
					break;															// break out of the loop to avoid removing more than one per click
				}
			}
		}
		
		private function update( event:Event ):void
		{
			for ( var i:int = 0; i < holder.length; i++ )
			{
				var ps:PixelSprite = holder[i];										// grab a reference to each PixelSprite
				
				if ( ps.x + ps.width > stageWidth )									// bounce off of the walls
				{
					ps.x = stageWidth - ps.width;
					ps.vx = -ps.vx;
				}
				else if ( ps.x < 0 )
				{
					ps.x = 0;
					ps.vx = -ps.vx;
				}
				if ( ps.y + ps.height > stageHeight )
				{
					ps.y = stageHeight - ps.height;
					ps.vy = -ps.vy;
				}
				else if ( ps.y < 0 )
				{
					ps.y = 0;
					ps.vy = -ps.vy;
				}
				
				ps.x += ps.vx; 														// move on the x axis
				ps.y += ps.vy;														// move on the y axis
			}
			
			//mouse.x += ( stage.mouseX - 275 ) * .1;												// update the mouse point
			//mouse.y += ( stage.mouseY - 200 ) * .1;
			
			renderer.render();													// render everything
		}
	}
}