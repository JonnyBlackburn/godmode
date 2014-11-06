package buttons
{
	import com.adobe.nativeExtensions.Vibration;

	import flash.filesystem.File;

	import starling.animation.Tween;
	import starling.core.Starling;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	public class Button1 extends AbstractState
	{
		private static const EDGE_BUFFER:Number = 10;
		private static const lightOffColour:uint = 0xAA0000;
		private static const lightOnColour:uint = 0x08AA00;

		private var assetManager:AssetManager;
		private var inputState:InputState;
		private var vibe:Vibration;

		private var buttonSprite:Sprite;
		private var buttonBg:Image;
		private var offText:Image;
		private var onText:Image;
		private var slider:Sprite;
		private var slideBtn:Image;
		private var buttonLight:Image;
		private var offPosition:Number;
		private var onPosition:Number;
		private var buttonActive:Boolean = false;
		private var previousState:Boolean;
		private var sliding:Boolean = false;

		private var offPosTween:Tween;
		private var onPosTween:Tween;

		public function Button1()
		{
			super();

			assetManager = Assets.getAssetManagerInstance();
			inputState = InputState.getInstance();
			if(CONFIG::mobile) vibe = Vibrator.getInstance();

			var appDir:File = File.applicationDirectory;
			assetManager.enqueue(appDir.resolvePath(Assets.ASSET_DIR + "button1/"));
			assetManager.loadQueue(onProgress);
		}

		private function onProgress(ratio:Number):void
		{
			if(ratio == 1) assetsLoaded();
		}

		private function assetsLoaded():void
		{
			buttonSprite = new Sprite();
			buttonSprite.x = Assets.GAME_WIDTH / 2;
			buttonSprite.y = Assets.GAME_HEIGHT / 2;

			buttonBg = new Image(assetManager.getTexture(Assets.BUTTON_BG));
			buttonBg.pivotX = buttonBg.width / 2;
			buttonBg.pivotY = buttonBg.height / 2;
			buttonSprite.addChild(buttonBg);

			offText = new Image(assetManager.getTexture(Assets.OFF_TXT));
			offText.pivotX = offText.width / 2;
			offText.pivotY = offText.height / 2;
			offText.x =  25;
			offText.visible = false;
			buttonSprite.addChild(offText);

			onText = new Image(assetManager.getTexture(Assets.ON_TXT));
			onText.pivotX = onText.width / 2;
			onText.pivotY = onText.height / 2;
			onText.x =  -25;
			onText.visible = false;
			buttonSprite.addChild(onText);

			view.addChild(buttonSprite);

			slider = new Sprite();
			slider.touchable = true;
			slider.x = Assets.GAME_WIDTH / 2;
			slider.y = Assets.GAME_HEIGHT / 2;

			slideBtn = new Image(assetManager.getTexture(Assets.SLIDE_BTN));
			slideBtn.pivotX = slideBtn.width / 2;
			slideBtn.pivotY = slideBtn.height / 2;
			slideBtn.y = 4;
			slider.addChild(slideBtn);

			buttonLight = new Image(assetManager.getTexture(Assets.BUTTON_LIGHT));
			buttonLight.pivotX = buttonLight.width / 2;
			buttonLight.pivotY = buttonLight.height / 2;
			buttonLight.x = -4;
			slider.addChild(buttonLight);

			view.addChild(slider);

			offPosition = (buttonSprite.x - (buttonSprite.width / 2)) + (slider.width / 2) + EDGE_BUFFER;
			onPosition = (buttonSprite.x + (buttonSprite.width / 2)) - (slider.width / 2);

			slider.x = offPosition;
			setButtonActive(false);

			slider.addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function setButtonActive(value:Boolean):void
		{
			if(value)
			{
				previousState = buttonActive;
				buttonActive = value;
				vibrateCheck();
				buttonLight.color = lightOnColour;
				offText.visible = false;
				onText.visible = true;
			}
			else
			{
				previousState = buttonActive;
				buttonActive = value;
				vibrateCheck();
				buttonLight.color = lightOffColour;
				offText.visible = true;
				onText.visible = false;
			}
		}

		private function vibrateCheck():void
		{
			if(vibe != null && previousState != buttonActive) vibe.vibrate(200);
		}

		private function btnCloserToOffPos():Boolean
		{
			return Math.abs(slider.x - offPosition) < Math.abs(slider.x - onPosition);
		}

		private function onTouch(e:TouchEvent):void
		{
			var startTouches:Vector.<Touch> = e.getTouches(view, TouchPhase.BEGAN);
			if (startTouches.length > 0)
			{
				inputState.mouseWasPressed = false;
				inputState.mousePressed = true;
				onTouchBegin();
			}

			var moveTouches:Vector.<Touch> = e.getTouches(view, TouchPhase.MOVED);
			if (moveTouches.length > 0)
			{
				inputState.mouseWasPressed = true;
				inputState.mousePressed = true;
				onTouchMove(moveTouches[0]);
			}

			var endTouches:Vector.<Touch> = e.getTouches(slider, TouchPhase.ENDED);
			if(endTouches.length > 0)
			{
				inputState.mouseWasPressed = true;
				inputState.mousePressed = false;
				onTouchEnd(endTouches[0]);
			}
		}

		private function onTouchBegin():void
		{
			sliding = true;
		}

		private function onTouchMove(touch:Touch):void
		{
			if(sliding)
			{
				if(touch.globalX > offPosition && touch.globalX < onPosition)
				{
					slider.x = touch.globalX;
					setButtonActive(!btnCloserToOffPos());
				}
			}
		}

		private function onTouchEnd(touch:Touch):void
		{
			sliding = false;
			if(btnCloserToOffPos())
			{
				offPosTween = new Tween(slider, 0.1);
				offPosTween.moveTo(offPosition, slider.y);
				Starling.juggler.add(offPosTween);
				setButtonActive(false);
			}
			else
			{
				onPosTween = new Tween(slider, 0.1);
				onPosTween.moveTo(onPosition, slider.y);
				Starling.juggler.add(onPosTween);
				setButtonActive(true);
			}
		}
	}
}
