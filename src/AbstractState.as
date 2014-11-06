package
{
	import starling.display.Sprite;

	public class AbstractState
	{
		protected var stateManager:StateManager;
		public var view:Sprite;

		public function AbstractState()
		{
			view = new Sprite();
		}

		public function init(game:StateManager):void
		{
			this.stateManager = game;
		}

		public function update(dt:Number):void
		{
		}

		public function dispose():void
		{
		}
	}
}
