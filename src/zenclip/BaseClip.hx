package zenclip;

import tink.CoreApi.Signal;
import tink.CoreApi.SignalTrigger;

class BaseClip implements IClip {
	public function new() {
		_state = State.Pending;
		_onPlay = new SignalTrigger();
		_onPause = new SignalTrigger();
		_onResume = new SignalTrigger();
		_onKill = new SignalTrigger();
		_onComplete = new SignalTrigger();
	}

	public var state(get, null):State;

	private var _state:State;

	public function get_state():State {
		return _state;
	}

	public var onPlay(get, null):Signal<IClip>;

	private var _onPlay:SignalTrigger<IClip>;

	public function get_onPlay():Signal<IClip> {
		return _onPlay.asSignal();
	}

	public var onPause(get, null):Signal<IClip>;

	private var _onPause:SignalTrigger<IClip>;

	public function get_onPause():Signal<IClip> {
		return _onPause.asSignal();
	}

	public var onResume(get, null):Signal<IClip>;

	private var _onResume:SignalTrigger<IClip>;

	public function get_onResume():Signal<IClip> {
		return _onResume.asSignal();
	}

	public var onComplete(get, null):Signal<IClip>;

	private var _onComplete:SignalTrigger<IClip>;

	public function get_onComplete():Signal<IClip> {
		return _onComplete.asSignal();
	}

	public var onKill(get, null):Signal<IClip>;

	private var _onKill:SignalTrigger<IClip>;

	public function get_onKill():Signal<IClip> {
		return _onKill.asSignal();
	}

	public function play():IClip {
		if (_state != State.Pending) {
			return this;
		}
		_state = State.Playing;
		doPlay();
		_onPlay.trigger(this);
		return this;
	}

	private function doPlay():Void {}

	public function pause():IClip {
		if (_state != State.Playing) {
			return this;
		}
		_state = State.Paused;
		doPause();
		_onPause.trigger(this);
		return this;
	}

	private function doPause():Void {}

	public function resume():IClip {
		if (_state != State.Paused) {
			return this;
		}
		_state = State.Playing;
		doResume();
		_onResume.trigger(this);
		return this;
	}

	private function doResume():Void {}

	public function kill():IClip {
		if (_state == State.Killed || _state == State.Completed) {
			return this;
		}
		_state = State.Killed;
		doKill();
		_onKill.trigger(this);
		return this;
	}

	private function doKill():Void {}

	public function complete():Void {
		if (_state != State.Playing) {
			return;
		}
		_state = State.Completed;
		doComplete();
		_onComplete.trigger(this);
	}

	private function doComplete():Void {}
}
