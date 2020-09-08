package zenclip;

import tink.CoreApi.Signal;
import tink.CoreApi.CallbackLink;

class Timer extends BaseClip {
	public function new(duration:Float, clockTick:Signal<Float>) {
        super();
        _remaining = duration;
		this._clockLink = clockTick.handle(onParentTick);
    }
    
    private var _clockLink:CallbackLink;
    private var _remaining:Float = 0;

	public var remaining(get, null):Float;

	public function get_remaining():Float {
		return _remaining;
    }
    
    private function onParentTick(delta:Float) {
        if (_state != State.Playing){
            return;
        }
        _remaining -= delta;
        if (_remaining <= 0){
            _remaining = 0;
            complete();
        }
    }

    private override function doComplete() {
		doKill();
	}

	private override function doKill() {
        _clockLink.cancel();
	}
}