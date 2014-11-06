package
{
	import starling.utils.AssetManager;

	public class Assets
	{
		private static var instance:AssetManager;

		public static const ASSET_DIR:String = "assets/";

		public static const GAME_WIDTH:int = 540;
		public static const GAME_HEIGHT:int = 960;

		public static const BG:String = "background";

		//Button 1
		public static const BUTTON_BG:String = "buttonBg";
		public static const BUTTON_LIGHT:String = "buttonLight";
		public static const OFF_TXT:String = "offTxt";
		public static const ON_TXT:String = "onTxt";
		public static const SLIDE_BTN:String = "slideBtn";

		public static function getAssetManagerInstance():AssetManager
		{
			if(!instance) instance = new AssetManager();
			return instance;
		}
	}
}
