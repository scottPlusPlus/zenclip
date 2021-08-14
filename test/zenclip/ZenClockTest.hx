package test.zenclip;

import utest.ITest;
import utest.Assert;
import zenclip.*;
import test.TestClock;

class ZenClockTest extends utest.Test {
	function testKeepsTime() {
		var testClock = new TestClock();
		var zenClock = new ZenClock();
		testClock.signalDelta.asSignal().handle(zenClock.tick);
		zenClock.play();

		testClock.tick(1.0);
		Assert.same(1.0, zenClock.delta);
		Assert.same(1.0, zenClock.time);

		testClock.tick(1.1);
		Assert.same(0.1, zenClock.delta);
		Assert.same(1.1, zenClock.time);

		testClock.tick(1.5);
		Assert.same(0.4, zenClock.delta);
		Assert.same(1.5, zenClock.time);
	}

	function testAlarms() {
		var testClock = new TestClock();
		var zenClock = new ZenClock();
		testClock.signalDelta.asSignal().handle(zenClock.tick);
		zenClock.play();

		var alarm1Complete = false;
		var alarm2Complete = false;
		var alarm3Complete = false;

		zenClock.setAlarm(2.0).handle(function(_) {
			alarm2Complete = true;
		});
		zenClock.setAlarm(1.0).handle(function(_) {
			alarm1Complete = true;
		});
		zenClock.setAlarm(3.0).handle(function(_) {
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
