package zenclip;

import tink.CoreApi.Signal;

interface IClip {
	function play():IClip;
	function pause():IClip;
	function resume():IClip;
	function kill():IClip;

    var state(get, null):State;

	var onPlay(get, null):Signal<IClip>;
	var onPause(get, null):Signal<IClip>;
	var onResume(get, null):Signal<IClip>;
	var onComplete(get, null):Signal<IClip>;
	var onKill(get, null):Signal<IClip>;
}

