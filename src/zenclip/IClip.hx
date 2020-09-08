package zenclip;

import tink.CoreApi.Signal;

interface IClip {
	function play():Void;
	function pause():Void;
	function resume():Void;
	function kill():Void;

    var state(get, null):State;

	var onPlay(get, null):Signal<IClip>;
	var onPause(get, null):Signal<IClip>;
	var onResume(get, null):Signal<IClip>;
	var onComplete(get, null):Signal<IClip>;
	var onKill(get, null):Signal<IClip>;
}

