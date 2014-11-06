package
{
	import flash.geom.Point;

	public class InputState
	{
		private static var instance:InputState;

		public var mousePressed:Boolean = false;
		public var mouseWasPressed:Boolean = false;

		public function InputState()
		{
		}

		public static function getInstance():InputState
		{
			if(!instance) instance = new InputState();

			return instance;
		}
	}
}
