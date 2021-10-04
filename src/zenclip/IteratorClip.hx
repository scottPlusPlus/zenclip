package zenclip;

class IteratorClip extends BaseClip {

    private var _iterator:Iterator<IClip>;
    private var _activeClip:IClip;

    public function new(iterator:Iterator<IClip>) {
		super();
		_iterator = iterator;
	}

    private override function doPlay() {
		nextClip();
	}

	private function nextClip() {
        if (!_iterator.hasNext()){
            complete();
            return;
        }
		_activeClip = _iterator.next();
		_activeClip.onComplete.nextTime().handle(clipComplete);
		_activeClip.onKill.nextTime().handle(clipComplete);
		_activeClip.play();
	}

	private function clipComplete(_:IClip) {
		nextClip();
	}

	private override function doPause() {
		_activeClip.pause();
	}

	private override function doResume() {
		_activeClip.resume();
	}

	private override function doComplete() {
		_activeClip = null;
        _iterator = null;
	}

	private override function doKill() {
		_activeClip.kill();
		_activeClip = null;
        _iterator = null;
	}

}