package zenclip;

import tink.CoreApi.Signal;
import tink.CoreApi.CallbackLink;

class TimerOld extends BaseClip {
	public function new(duration:Float, clockTick:Signal<Float>, clockTime:Void->Float) {
		super();
		this._clockLink = clockTick.handle(onTick);
		this._clockTime = clockTime;
		this._remaining = duration;
	}

	public var remaining(get, null):Float;

	public function get_remaining():Float {
		if (_state == State.Playing) {
			// if playing, re-estimate
			// avoid changing actual value to avoid float-drift
			var r = _remaining - (_clockTime() - _resumed);
			return r;
		}
		return _remaining;
	}

	private var _clockLink:CallbackLink;
	private var _clockTime:Void->Float;

	private var _startTime:Float;

	private var _resumed:Float;
	private var _remaining:Float;
	private var _endTime:Float;

	private function onTick(time:Float) {
		if (_state != State.Playing) {
			return;
		}
		if (time >= _endTime) {
			complete();
		}
	}

	private override function doPlay() {
		doResume();
	}

	private override function doPause() {
		_remaining -= (_clockTime() - _resumed);
		_resumed = -1;
	}

	private override function doResume() {
		_resumed = _clockTime();
		_endTime = _resumed + _remaining;
	}

	private override function doComplete() {
		doKill();
	}

	private override function doKill() {
		_remaining = 0;
		_clockLink.cancel();
		_clockTime = null;
	}
}