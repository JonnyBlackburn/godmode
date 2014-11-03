package
{
	import com.adobe.nativeExtensions.Vibration;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.ColorTransform;

	public class Main extends Sprite
	{
		private var backgroundWidth:int = 540;
		private var backgroundHeight:int = 960;
		private var fullscreenWidth:Number;
		private var fullscreenHeight:Number;

		private var offPos:Number;
		private var onPos:Number;
		private var edgeBuffer:Number = 10;
		private var vibe:Vibration;

		private var sliding:Boolean = false;
		private var dragged:Boolean = false;
		private var godModeActive:Boolean = false;

		private var slideBtn:Sprite;
		private var offText:Bitmap;
		private var onText:Bitmap;
		private var light:Bitmap;
		private var lightOnColour:ColorTransform;
		private var lightOffColour:ColorTransform;

		[Embed(source="/../assets/background.jpg")]
		public static const background:Class;

		[Embed(source="/../assets/buttonBg.png")]
		public static const buttonBackground:Class;

		[Embed(source="/../assets/slideBtn.png")]
		public static const slideButton:Class;

		[Embed(source="/../assets/buttonLight.png")]
		public static const buttonLight:Class;

		[Embed(source="/../assets/offTxt.png")]
		public static const offTxt:Class;

		[Embed(source="/../assets/onTxt.png")]
		public static const onTxt:Class;

	    public function Main()
	    {
		    stage.scaleMode = StageScaleMode.NO_SCALE;
		    stage.align = StageAlign.TOP_LEFT;
		    stage.color = 0x1e1e1e;

		    fullscreenWidth = stage.fullScreenWidth;
		    fullscreenHeight = stage.fullScreenHeight;

		    if(Vibration.isSupported) vibe = new Vibration();

		    var scaleWidthRatio:Number = fullscreenWidth / backgroundWidth;
		    var scaleHeightRatio:Number = fullscreenHeight / backgroundHeight;

		    lightOffColour = new ColorTransform(0.6, 0, 0);
		    lightOnColour = new ColorTransform(0.03, 0.6, 0);

		    var bg:Bitmap = new background;
		    addChild(bg);
		    if (scaleWidthRatio > 1) bg.scaleX = scaleWidthRatio;
		    if (scaleHeightRatio > 1) bg.scaleY = scaleHeightRatio;

		    var buttonSprite:Sprite = new Sprite();

		    var buttonBG:Bitmap = new buttonBackground;
		    buttonBG.x -= buttonBG.width / 2;
		    buttonBG.y -= buttonBG.height / 2;
		    buttonSprite.addChild(buttonBG);

		    offText = new offTxt;
		    offText.x -= (offText.width / 2) - 25;
		    offText.y -= offText.height / 2;
		    offText.visible = false;
		    buttonSprite.addChild(offText);

		    onText = new onTxt;
		    onText.x -= (onText.width / 2) + 25;
		    onText.y -= onText.height / 2;
		    onText.visible = false;
		    buttonSprite.addChild(onText);

		    buttonSprite.x = fullscreenWidth / 2;
		    buttonSprite.y = fullscreenHeight / 2;
		    buttonSprite.scaleX = buttonSprite.scaleY = scaleWidthRatio;
		    addChild(buttonSprite);

		    var slideBtnBitmap:Bitmap = new slideButton;
		    slideBtnBitmap.x -= slideBtnBitmap.width / 2;
		    slideBtnBitmap.y -= (slideBtnBitmap.height / 2) - 4;

		    light = new buttonLight;
		    light.x -= (light.width / 2) + 4;
		    light.y -= light.height / 2;

		    slideBtn = new Sprite();
		    slideBtn.addChild(slideBtnBitmap);
		    slideBtn.addChild(light);

		    slideBtn.scaleX = slideBtn.scaleY = scaleWidthRatio;

		    slideBtn.x = fullscreenWidth / 2;
		    slideBtn.y = fullscreenHeight / 2;

		    slideBtn.addEventListener(TouchEvent.TOUCH_TAP, onTouchTap);
		    slideBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		    slideBtn.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		    slideBtn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		    slideBtn.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
		    slideBtn.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		    slideBtn.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		    slideBtn.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		    slideBtn.addEventListener(TouchEvent.TOUCH_OUT, onTouchEnd);
		    slideBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);

		    addChild(slideBtn);

		    offPos = (buttonSprite.x - (buttonSprite.width / 2)) + (slideBtn.width / 2) + edgeBuffer;
		    onPos = (buttonSprite.x + (buttonSprite.width / 2)) - (slideBtn.width / 2);

		    setGodMode(false);
	    }

		private function setGodMode(value:Boolean, snapBtn:Boolean = true):void
		{
			godModeActive = value;

			if(godModeActive)
			{
				if(snapBtn)
				{
					slideBtn.x = onPos;
					if(vibe != null) vibe.vibrate(200);
				}
				light.transform.colorTransform = lightOnColour;
				offText.visible = false;
				onText.visible = true;

			}
			else
			{
				if(snapBtn) slideBtn.x = offPos;
				light.transform.colorTransform = lightOffColour;
				offText.visible = true;
				onText.visible = false;
			}

		}

		private function btnCloserToOffPos():Boolean
		{
			return Math.abs(slideBtn.x - offPos) < Math.abs(slideBtn.x - onPos);
		}

		private function onTouchTap(e:TouchEvent):void
		{
			if(!dragged) setGodMode(!godModeActive);

			dragged = false;
		}

		private function onMouseClick(e:MouseEvent):void
		{
			if(!dragged) setGodMode(!godModeActive);

			dragged = false;
		}

		private function onTouchBegin(e:TouchEvent):void
		{
			sliding = true;
		}

		private function onMouseDown(e:MouseEvent):void
		{
			sliding = true;
		}

		private function onTouchMove(e:TouchEvent):void
		{
			if(sliding)
			{
				dragged = true;
				if(e.stageX > offPos && e.stageX < onPos)
				{
					slideBtn.x = e.stageX;
					setGodMode(!btnCloserToOffPos(), false);
				}
			}
		}

		private function onMouseMove(e:MouseEvent):void
		{
			if(sliding)
			{
				dragged = true;
				if(e.stageX > offPos && e.stageX < onPos)
				{
					slideBtn.x = e.stageX;
					setGodMode(!btnCloserToOffPos(), false);
				}
			}
		}

		private function onTouchEnd(e:TouchEvent):void
		{
			sliding = false;
		}

		private function onMouseUp(e:MouseEvent):void
		{
			sliding = false;
			if(btnCloserToOffPos())
			{
				slideBtn.x = offPos;
				setGodMode(false);
			}
			else
			{
				slideBtn.x = onPos;
				setGodMode(true);
			}
		}
	}
}
