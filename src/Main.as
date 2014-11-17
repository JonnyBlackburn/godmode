package
{
	import buttons.Button1;

	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class Main extends Sprite
	{
		private var assetManager:AssetManager;

		private var scene:Starling;
		private var game:StateManager;

	    public function Main()
	    {
		    var viewport:Rectangle;

		    if(CONFIG::mobile)
		    {
		        viewport = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
		    }
		    else
		    {
			    viewport = new Rectangle(0, 0, Assets.GAME_WIDTH, Assets.GAME_HEIGHT);

			    stage.nativeWindow.width = Assets.GAME_WIDTH;
			    stage.nativeWindow.height = Assets.GAME_HEIGHT;

			    //Native window doesn't take into account the chrome size,
			    //so we need to add it on to see the whole stage
			    stage.nativeWindow.height += stage.nativeWindow.height - stage.stageHeight;
			    stage.nativeWindow.width += stage.nativeWindow.width - stage.stageWidth;
		    }

		    scene = new Starling(
			    StarlingRoot,
			    stage,
			    viewport,
			    null,
			    "auto",
			    [Context3DProfile.BASELINE_EXTENDED, Context3DProfile.BASELINE, Context3DProfile.BASELINE_CONSTRAINED]
		    );

		    scene.stage.stageWidth = Assets.GAME_WIDTH;
		    scene.stage.stageHeight = Assets.GAME_HEIGHT;

		    scene.stage.color = 0x1e1e1e;

		    scene.supportHighResolutions = true;
		    scene.stage3D.addEventListener(Event.CONTEXT3D_CREATE, context3DCreateHandler);

		    NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onAppActivated);
		    NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onAppDeactivated);
	    }

		private function onAppActivated(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			scene.start();
		}

		private function onAppDeactivated(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
			scene.stop();
		}

		private function context3DCreateHandler(event:Event = null):void
		{
			scene.stage3D.removeEventListener(Event.CONTEXT3D_CREATE, context3DCreateHandler);

			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			scene.start();

			game = new StateManager();
			scene.stage.addChild(game.view);

			var appDir:File = File.applicationDirectory;

			assetManager = Assets.getAssetManagerInstance();
			assetManager.enqueue(Assets.BG);
			assetManager.loadQueue(onProgress);
		}

		private function onProgress(ratio:Number):void
		{
			if(ratio == 1) assetsLoaded();
		}

		private function assetsLoaded():void
		{
			var bg:Image = Image.fromBitmap(new Assets.BG());
			game.view.addChild(bg);
			game.currentState = new Button1();
		}

	}

}
