package buttons
{
	import com.adobe.nativeExtensions.Vibration;

	import flash.filesystem.File;
	import flash.geom.Rectangle;

	import starling.display.Image;

	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class NoClip extends Sprite
	{
		private static const NO_CLIP_OFF:uint = 0xAA0000;
		private static const NO_CLIP_ON:uint = 0x08AA00;
		private static const LIGHT_OFFSET_X:int = 4;
		private static const LIGHT_OFFSET_Y:int = 5;
		private static const TEXT_OFFSET_X:int = 20;
		private static const TEXT_OFFSET_Y:int = 4;

		private var assetManager:AssetManager;
		private var vibe:Vibration;

		private var buttonSprite:Sprite;
		private var buttonBg:Image;
		private var buttonLight:Image;
		private var noClipTxt:Image;
		private var touchRect:Image;

		private var currentState:Boolean = false;

		public function NoClip()
		{
			assetManager = Assets.getAssetManagerInstance();
			if(CONFIG::mobile) vibe = Vibrator.getInstance();

			var appDir:File = File.applicationDirectory;
			assetManager.enqueue(appDir.resolvePath(Assets.ASSET_DIR + "noClip/"));
			assetManager.loadQueue(onProgress);
		}

		private function onProgress(ratio:Number):void
		{
			if(ratio >= 1) assetsLoaded();
		}

		private function assetsLoaded():void
		{
			touchRect = new Image(Texture.empty(130, 50));
			addChild(touchRect);

			buttonSprite = new Sprite();
			buttonSprite.pivotX = buttonSprite.width / 2;
			buttonSprite.pivotY = buttonSprite.height / 2;

			buttonBg = new Image(assetManager.getTexture(Assets.NO_CLIP_BUTTON_BG));
			buttonBg.pivotX = buttonBg.width / 2;
			buttonBg.pivotY = buttonBg.height / 2;
			buttonSprite.addChild(buttonBg);

			buttonLight = new Image(assetManager.getTexture(Assets.NO_CLIP_BUTTON_LIGHT));
			buttonLight.pivotX = buttonLight.width / 2;
			buttonLight.pivotY = buttonLight.height / 2;

			//Need to add offset to the light because of the glow
			buttonLight.x += LIGHT_OFFSET_X;
			buttonLight.y += LIGHT_OFFSET_Y;

			buttonLight.color = NO_CLIP_OFF;

			buttonSprite.x += 15;
			buttonSprite.y = height / 2;
			buttonSprite.addChild(buttonLight);

			//Text is aligned from the left, so no need to center the pivot
			noClipTxt = new Image(assetManager.getTexture(Assets.NO_CLIP_TXT));
			noClipTxt.pivotY = noClipTxt.height / 2;

			noClipTxt.x = buttonSprite.x + TEXT_OFFSET_X;
			noClipTxt.y = buttonSprite.y + TEXT_OFFSET_Y;

			addChild(noClipTxt);
			addChild(buttonSprite);

			addEventListener(TouchEvent.TOUCH, onTouch);

			//Set the pivot after everything has been added
			pivotX = width / 2;
			pivotY = height / 2;
		}

		private function onTouch(e:TouchEvent):void
		{
			var endTouches:Vector.<Touch> = e.getTouches(this, TouchPhase.ENDED);
			if(endTouches.length > 0) onTouchEnd();
		}

		private function onTouchEnd():void
		{
			currentState = !currentState;

			if(currentState)
			{
				buttonLight.color = NO_CLIP_ON;
			}
			else
			{
				buttonLight.color = NO_CLIP_OFF;
			}

			if(vibe != null) vibe.vibrate(50);
		}
	}
}
