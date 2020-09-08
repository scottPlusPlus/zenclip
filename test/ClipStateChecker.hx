package test;

import zenclip.*;

class ClipStateChecker {
	public function new(c:IClip) {
		clip = c;
		onPlayChecker = new SignalTester(clip.onPlay);
		onPauseChecker = new SignalTester(clip.onPause);
		onResumeChecker = new SignalTester(clip.onResume);
		onCompleteChecker = new SignalTester(clip.onComplete);
		onKillChecker = new SignalTester(clip.onKill);
	}

	public var clip:IClip;
	public var onPlayChecker:SignalTester<IClip>;
	public var onPauseChecker:SignalTester<IClip>;
	public var onResumeChecker:SignalTester<IClip>;
	public var onCompleteChecker:SignalTester<IClip>;
	public var onKillChecker:SignalTester<IClip>;

	public function state():ClipState {
		return {
			state: clip.state,
			playCount: onPlayChecker.count(),
			pauseCount: onPauseChecker.count(),
			resumeCount: onResumeChecker.count(),
			completeCount: onCompleteChecker.count(),
			killCount: onKillChecker.count()
		}
	}

	public function emptyClipState():ClipState {
		return {
			state: State.Pending,
			playCount: 0,
			pauseCount: 0,
			resumeCount: 0,
			completeCount: 0,
			killCount: 0
		}
	}
}

typedef ClipState = {
	var state:State;
	var playCount:Int;
	var pauseCount:Int;
	var resumeCount:Int;
	var completeCount:Int;
	var killCount:Int;
}
