package
{
	import com.adobe.nativeExtensions.Vibration;

	public class Vibrator
	{
		private static var instance:Vibration;

		public static function getInstance():Vibration
		{
			if(!instance)
			{
				if(Vibration.isSupported)
				{
					instance = new Vibration();
				}
				else
				{
					trace("Vibration not supported");
				}
			}

			return instance;
		}
	}
}
