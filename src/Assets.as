package
{
	import starling.utils.AssetManager;

	public class Assets
	{
		private static var instance:AssetManager;

		public static const ASSET_DIR:String = "assets/";

		public static const GAME_WIDTH:int = 540;
		public static const GAME_HEIGHT:int = 960;

		[Embed(source="../assets/background.jpg")]
		public static const BG:Class;

		//Button 1
		public static const BUTTON_BG:String = "buttonBg";
		public static const BUTTON_LIGHT:String = "buttonLight";
		public static const OFF_TXT:String = "offTxt";
		public static const ON_TXT:String = "onTxt";
		public static const SLIDE_BTN:String = "slideBtn";

		//No Clip
		public static const NO_CLIP_BUTTON_BG:String = "noClipButtonBg";
		public static const NO_CLIP_BUTTON_LIGHT:String = "noClipButtonLight";
		public static const NO_CLIP_TXT:String = "noClipTxt";


		public static function getAssetManagerInstance():AssetManager
		{
			if(!instance) instance = new AssetManager();
			return instance;
		}
	}
}
