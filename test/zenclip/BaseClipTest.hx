package test.zenclip;

import utest.ITest;
import utest.Assert;
import zenclip.*;
import test.TestClock;

class BaseClipTest extends utest.Test {
	function testLifecyclePlay() {
		var clip = new BaseClip();
		Assert.equals(State.Pending, clip.state);

		var stateChecker = new ClipStateChecker(clip);
		var expected = stateChecker.emptyClipState();

		clip.pause(); // no effect
		Assert.same(expected, stateChecker.state());
		clip.resume(); // no effect
		Assert.same(expected, stateChecker.state());
		clip.complete(); // no effect
		Assert.same(expected, stateChecker.state());

		// Actually play
		clip.play();
		expected.state = State.Playing;
		expected.playCount = 1;
		Assert.same(expected, stateChecker.state());

		clip.play(); // 2nd time, no effect
		Assert.same(expected, stateChecker.state());
		clip.resume(); // no effect
		Assert.same(expected, stateChecker.state());
	}

	function testLifecyclePauseResume() {
		var clip = new BaseClip();
		var stateChecker = new ClipStateChecker(clip);

		clip.play();
		var expected = stateChecker.state();
		Assert.same(expected, stateChecker.state());

		// Actually pause
		clip.pause();
		expected.state = State.Paused;
		expected.pauseCount = 1;
		Assert.same(expected, stateChecker.state());

		clip.play(); // no effect
		Assert.same(expected, stateChecker.state());
		clip.pause(); // no effect
		Assert.same(expected, stateChecker.state());

		// Actually resume
		clip.resume();
		expected.state = State.Playing;
		expected.resumeCount = 1;

		clip.play(); // no effect
		Assert.same(expected, stateChecker.state());
		clip.resume(); // no effect
		Assert.same(expected, stateChecker.state());

		// Pause Again
		clip.pause();
		expected.state = State.Paused;
		expected.pauseCount = 2;
		Assert.same(expected, stateChecker.state());

		// Resume again
		clip.resume();
		expected.state = State.Playing;
		expected.resumeCount = 2;
	}

	function testLifecycleComplete() {
		var clip = new BaseClip();
		var stateChecker = new ClipStateChecker(clip);

		clip.play();
		var expected = stateChecker.state();
		Assert.same(expected, stateChecker.state());

		// Complete
		clip.complete();
		expected.state = State.Completed;
		expected.completeCount = 1;
		clip.play(); // no effect
		Assert.same(expected, stateChecker.state());
		clip.pause(); // no effect
		Assert.same(expected, stateChecker.state());
		clip.resume(); // no effect
		Assert.same(expected, stateChecker.state());
		clip.complete(); // no effect
		Assert.same(expected, stateChecker.state());
		clip.kill(); // no effect
		Assert.same(expected, stateChecker.state());
	}

	function testLifecycleKill() {
		var clip = new BaseClip();
		var stateChecker = new ClipStateChecker(clip);

		clip.play();
		var expected = stateChecker.state();
		Assert.same(expected, stateChecker.state());

		clip.kill();
		expected.state = State.Killed;
		expected.killCount = 1;
		clip.play(); // no effect
		Assert.same(expected, stateChecker.state());
		clip.pause(); // no effect
		Assert.same(expected, stateChecker.state());
		clip.resume(); // no effect
		Assert.same(expected, stateChecker.state());
		clip.complete(); // no effect
		Assert.same(expected, stateChecker.state());
		clip.kill(); // no effect
		Assert.same(expected, stateChecker.state());

		// test can kill from Pending
		clip = new BaseClip();
		stateChecker = new ClipStateChecker(clip);
		expected = stateChecker.state();

		clip.kill();
		expected.state = State.Killed;
		expected.killCount = 1;
		Assert.same(expected, stateChecker.state());

		// test can kill from Paused
		clip = new BaseClip();
		stateChecker = new ClipStateChecker(clip);
		clip.play();
		clip.pause();
		expected = stateChecker.state();

		clip.kill();
		expected.state = State.Killed;
		expected.killCount = 1;
		Assert.same(expected, stateChecker.state());
	}
}
