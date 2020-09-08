package zenclip;

import tink.CoreApi.Signal;

class Timeline extends BaseClip {

    private var _activeClips:Array<IClip> = [];
    private var _pendingClips:Int = 0;
    var _clock:GameClock;

    public function new(clockTick:Signal<Float>, markers:Array<Marker>){
        super();
        _clock = new GameClock(clockTick);
        _activeClips.push(_clock);
        _pendingClips = markers.length;
        for(m in markers){
            var alarm = _clock.setAlarm(m.time);
            alarm.handle(function(_){markerReady(m);});
        }
    }

    private function markerReady(m:Marker){
        var c = m.clip;
        _activeClips.push(c);
        c.play();
        c.onComplete.handle(markerComplete);
        c.onKill.handle(markerComplete);
        _pendingClips--;
    }

    private function markerComplete(clip:IClip){
        _activeClips.remove(clip);
        if (_pendingClips == 0 && _activeClips.length == 1){
            complete();
        }
    }

    private override function doPlay(){
        _clock.play();
    }

    private override function doPause() {
		for(c in _activeClips){
            c.pause();
        }
	}

	private override function doResume() {
		for(c in _activeClips){
            c.resume();
        }
	}

	private override function doKill() {
		for(c in _activeClips){
            c.kill();
        }
        _activeClips = null;
    }
    
    private override function doComplete() {
        _clock.complete();
        _clock = null;
        _activeClips = null;
	}
}

class Marker {
    public function new(time_:Float, clip_:IClip){
        time = time_;
        clip = clip_;
    }
    public var time:Float;
    public var clip:IClip;
}