package zenclip;

import tink.CoreApi;

interface IClock {
	var onTick(get, null):Signal<Time>;
	var time(default, null):Float;
	var delta(default, null):Float;
	function setAlarm(t:Float):Future<Noise>;
}