package test.zenclip;

import utest.ITest;
import utest.Assert;
import zenclip.*;
import test.TestClock;

class TimerTest extends utest.Test {
	function testLifecylce() {
		var clock = new TestClock();
		var timer = new Timer(2, clock.signalDelta.asSignal());

		clock.tickFor(3); //does nothing before playing
		Assert.equals(State.Pending, timer.state);
		Assert.equals(2.0, timer.remaining);

		timer.play();
		clock.tickFor(1);
		Assert.equals(State.Playing, timer.state);
		Assert.equals(1.0, timer.remaining);

		timer.pause();
		clock.tickFor(3); //does nothing while paused
		Assert.equals(State.Paused, timer.state);
		Assert.equals(1.0, timer.remaining);

		timer.resume();
		clock.tickFor(1);
		Assert.equals(0, timer.remaining);
		Assert.equals(State.Completed, timer.state);
		
	}
}
