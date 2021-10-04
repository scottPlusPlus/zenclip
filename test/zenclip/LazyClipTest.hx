package test.zenclip;

import utest.Assert;
import zenclip.*;

class LazyClipTest extends utest.Test {
	function testLazyClip() {
		var internalClip = new EmptyClip();
		var createClipRuns = 0;
		var createClip = function():IClip {
			createClipRuns++;
			return internalClip;
		};
		var lazyClip = new LazyClip(createClip);
		Assert.equals(0, createClipRuns);
		Assert.equals(State.Pending, internalClip.state);
		Assert.equals(State.Pending, lazyClip.state);

		lazyClip.play();
		Assert.equals(1, createClipRuns);
		Assert.equals(State.Completed, internalClip.state);
		Assert.equals(State.Completed, lazyClip.state);
	}
}
