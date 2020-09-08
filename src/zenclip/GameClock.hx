package zenclip;

import tink.CoreApi.FutureTrigger;
import tink.CoreApi.Future;
import tink.CoreApi.Signal;
import tink.CoreApi.SignalTrigger;
import tink.CoreApi.Noise;
import tink.CoreApi.CallbackLink;

class GameClock extends BaseClip {
	public function new(clockTick:Signal<Float>) {
		super();
		_parentLink = clockTick.handle(onParentTick);
		_onTickTimeTrigger = new SignalTrigger<Float>();
		_onTickDeltaTrigger = new SignalTrigger<Float>();
		_onTickClockTrigger = new SignalTrigger<GameClock>();
	}

	private var _onTickTimeTrigger:SignalTrigger<Float>;

	public var onTickTime(get, null):Signal<Float>;

	public function get_onTickTime():Signal<Float> {
		return _onTickTimeTrigger.asSignal();
	}

	private var _onTickDeltaTrigger:SignalTrigger<Float>;

	public var onTickDelta(get, null):Signal<Float>;

	public function get_onTickDelta():Signal<Float> {
		return _onTickDeltaTrigger.asSignal();
	}

	private var _onTickClockTrigger:SignalTrigger<GameClock>;

	public var onTickClock(get, null):Signal<GameClock>;

	public function get_onTickClock():Signal<GameClock> {
		return _onTickClockTrigger.asSignal();
	}

	private var _parentLink:CallbackLink;

	private var _time:Float = 0;

	public var time(get, null):Float;

	public function get_time():Float {
		return _time;
	}

	private var _delta:Float = 0;

	public var delta(get, null):Float;

	public function get_delta():Float {
		return _delta;
	}

	private var _alarms:Array<Alarm> = [];

	public function setAlarm(t:Float):Future<Noise> {
		var a = new Alarm(t, new FutureTrigger<Noise>());
		var pos = _alarms.length;
		for (i in 0..._alarms.length) {
			if (t < _alarms[i].time) {
				pos = i;
				break;
			}
		}
		_alarms.insert(pos, a);
		return a.future.asFuture();
	}

	private function onParentTick(delta:Float) {
		if (_state != State.Playing) {
			return;
		}
		_delta = delta;
		_time += _delta;
		_onTickTimeTrigger.trigger(_time);
		_onTickDeltaTrigger.trigger(_delta);
		_onTickClockTrigger.trigger(this);
		checkAlarms();
	}

	private function checkAlarms() {
		if (_alarms.length == 0) {
			return;
		}
		if (_alarms[0].time > _time) {
			return;
		}
		_alarms[0].future.trigger(Noise);
		_alarms.shift();
		checkAlarms();
	}

	private override function doComplete() {
		doKill();
	}

	private override function doKill() {
		_onTickTimeTrigger = null;
		_onTickDeltaTrigger = null;
		_onTickClockTrigger = null;
		_parentLink.cancel();
	}
}

class Alarm {
	public function new(t:Float, f:FutureTrigger<Noise>) {
		time = t;
		future = f;
	}

	public var time:Float;
	public var future:FutureTrigger<Noise>;
}
