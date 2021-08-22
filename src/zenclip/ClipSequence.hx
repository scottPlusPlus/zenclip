package zenclip;

class ClipSequence extends BaseClip {

    private var _pendingClips:Array<IClip>;
    private var _activeClip:IClip;
    private var _index:Int;

    public function new(?clips:Array<IClip>){
        super();
        if (clips == null){
            _pendingClips = new Array<IClip>();
        } else {
            _pendingClips = clips.copy();
        }
        _index = 0;
    }

    public function push(c:IClip){
        if (_state == State.Completed || _state == State.Killed){
            throw("cannot add new clip to a completed Sequence");
        }
        #if debug
        if (c.state != State.Pending){
            trace("adding non-pending clip to a sequence. Probably not what you want to do");
        }
        #end
        _pendingClips.push(c);
    }

    private override function doPlay() {
        nextClip();
    }
    
    private function nextClip(){      
        if (_index == _pendingClips.length){
            complete();
            return;
        }
        _activeClip = _pendingClips[_index];
        _activeClip.onComplete.nextTime().handle(clipComplete);
        _activeClip.onKill.nextTime().handle(clipComplete);
        _activeClip.play();
    }

    private function clipComplete(_:IClip){
        _pendingClips[_index] = null;
        _index++;
        nextClip();
    }

	private override function doPause() {
		_activeClip.pause();
	}

	private override function doResume() {
		_activeClip.resume();
	}

	private override function doKill() {
        for (c in _pendingClips){
            c.kill();
        }
        _pendingClips = [];
        _activeClip.kill();
	}
}