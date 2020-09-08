package test.zenclip;

import utest.ITest;
import utest.Assert;
import zenclip.*;
import test.TestClock;

class SequenceTest extends utest.Test {
    
	function testHappy() {
		var testClock = new TestClock();
		var sequence = new Sequence([]);

		var timer = new Timer(1, testClock.signalDelta.asSignal());
		sequence.push(timer);
		sequence.push(new Timer(1, testClock.signalDelta.asSignal()));
		sequence.push(new Timer(1, testClock.signalDelta.asSignal()));

		sequence.play();
		testClock.tickFor(3.1);
		Assert.equals(State.Completed, sequence.state);
	}

	function testAddWhileRunning() {
		var testClock = new TestClock();
		var sequence = new Sequence([]);

		sequence.push(new Timer(1, testClock.signalDelta.asSignal()));
		sequence.play();
		testClock.tickTo(0.5);
		sequence.push(new Timer(1, testClock.signalDelta.asSignal()));
		testClock.tickTo(1.0);
		Assert.equals(State.Playing, sequence.state);
		testClock.tickTo(2.0);
		Assert.equals(State.Completed, sequence.state);
	}
}
