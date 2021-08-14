package zenclip;

import tink.CoreApi.FutureTrigger;
import tink.CoreApi.Future;
import tink.CoreApi.Signal;
import tink.CoreApi.SignalTrigger;
import tink.CoreApi.Noise;
import tink.CoreApi.CallbackLink;

class ZenClock extends BaseClip implements IClock {
	public function new() {
		super();
		_onTickTrigger = new SignalTrigger<Time>();
	}

	private var _onTickTrigger:SignalTrigger<Time>;
	public var onTick(get, null):Signal<Time>;
	public function get_onTick():Signal<Time> {
		return _onTickTrigger.asSignal();
	}

	public var time(default, null):Float= 0;
	public var delta(default, null):Float = 0;


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

	public function tick(delta_:Float) {
		if (_state != State.Playing) {
			return;
		}
		delta = delta_;
		time += delta;
		_onTickTrigger.trigger(new Time(time, delta));
		checkAlarms();
	}

	private function checkAlarms() {
		if (_alarms.length == 0) {
			return;
		}
		if (_alarms[0].time > time) {
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
		_onTickTrigger = null;
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
