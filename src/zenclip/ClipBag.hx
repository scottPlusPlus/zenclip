package zenclip;

class ClipBag extends BaseClip {

    var _children:Array<IClip> = [];
    
    public var completeOnEmpty:Bool;

    public function add(c:IClip){
        if (_state == State.Killed || _state == State.Completed){
            throw("cannot add clips to a ClipBag that has already completed");
        }

        if (_state == State.Playing){
            c.play();
        }
        if (_state == State.Paused){
            c.play();
            c.pause();
        }
        c.onComplete.nextTime().handle(removeChild);
        c.onKill.nextTime().handle(removeChild);
        _children.push(c);
    }

    private function removeChild(c:IClip){
        _children.remove(c);
        if (_children.length == 0){
            if (completeOnEmpty){
                complete();
            }
        }
    }

	private override function doPlay() {
		for(c in _children){
            c.play();
        }
	}

	private override function doPause() {
		for(c in _children){
            c.pause();
        }
	}

	private override function doResume() {
		for(c in _children){
            c.resume();
        }
	}

	private override function doKill() {
		for(c in _children){
            c.kill();
        }
	}
}