package
{
	import flash.events.Event;
	import flash.utils.getTimer;

	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;

	public class StateManager
	{
		protected var _currentState:AbstractState;

		private var currentTime:int;
		private var previousTime:int;
		private var dt:Number;

		public var view:Sprite;

		public function StateManager()
		{
			view = new Sprite();

			view.addEventListener(Event.ENTER_FRAME, onTick);
		}

		private function onTick(e:EnterFrameEvent):void
		{
			previousTime = currentTime;
			currentTime = getTimer();

			dt = (currentTime - previousTime) * 0.001; //convert milliseconds to seconds.

			if(currentState) currentState.update(dt);
		}

		public function get currentState():AbstractState { return _currentState; }

		public function set currentState(value:AbstractState):void
		{
			_currentState = value;
			view.addChild(_currentState.view);
			_currentState.init(this);
		}

		public function disposeCurrentState():void
		{
			if(_currentState)
			{
				_currentState.dispose();
				view.removeChild(_currentState.view);
				_currentState = null;
			}
		}
	}
}
