package test.zenclip;

import utest.ITest;
import utest.Assert;
import zenclip.*;
import test.TestClock;

class GameClockTest extends utest.Test {
	function testKeepsTime() {
		var testClock = new TestClock();
		var gameClock = new GameClock(testClock.signalDelta);
		gameClock.play();

		testClock.tick(1.0);
		Assert.same(1.0, gameClock.delta);
		Assert.same(1.0, gameClock.time);

		testClock.tick(1.1);
		Assert.same(0.1, gameClock.delta);
		Assert.same(1.1, gameClock.time);

		testClock.tick(1.5);
		Assert.same(0.4, gameClock.delta);
		Assert.same(1.5, gameClock.time);
	}

	function testAlarms() {
		var testClock = new TestClock();
		var gameClock = new GameClock(testClock.signalDelta);
		gameClock.play();

		var alarm1Complete = false;
		var alarm2Complete = false;
		var alarm3Complete = false;

		gameClock.setAlarm(2.0).handle(function(_) {
			alarm2Complete = true;
		});
		gameClock.setAlarm(1.0).handle(function(_) {
			alarm1Complete = true;
		});
		gameClock.setAlarm(3.0).handle(function(_) {
			alarm3Complete = true;
		});

		testClock.tickFor(1.00, 0.1);
		Assert.equals(true, alarm1Complete);
		Assert.equals(false, alarm2Complete);
		Assert.equals(false, alarm3Complete);
		testClock.tickFor(1.00, 0.1);
		Assert.equals(true, alarm2Complete);
		Assert.equals(false, alarm3Complete);
		testClock.tickFor(1.00, 0.1);
		Assert.equals(true, alarm3Complete);
	}
}
