package test.zenclip;

import utest.Assert;
import zenclip.*;

class IteratorClipTest extends utest.Test {

    public function testIteratorClip(){
        var clip1 = new EmptyClip();
        var clip2 = new BaseClip();
        var clip3 = new EmptyClip();
        var arr = [clip1, clip2, clip3];

        var iteratorClip = new IteratorClip(arr.iterator());
        iteratorClip.play();
        Assert.equals(State.Completed, clip1.state);
        Assert.equals(State.Playing, clip2.state);
        Assert.equals(State.Pending, clip3.state);

        iteratorClip.pause();
        Assert.equals(State.Paused, clip2.state);

        iteratorClip.resume();
        clip2.complete();
        Assert.equals(State.Completed, clip2.state);
        Assert.equals(State.Completed, clip3.state);
        Assert.equals(State.Completed, iteratorClip.state);
    }

    public function testAddWhileRunning(){
        var clip1 = new BaseClip();
        var arr = [clip1];

        var iteratorClip = new IteratorClip(arr.iterator());
        iteratorClip.play();
        var clip2 = new EmptyClip();
        arr.push(clip2);

        clip1.complete();
        Assert.equals(State.Completed, clip1.state);
        Assert.equals(State.Completed, clip2.state);
        Assert.equals(State.Completed, iteratorClip.state);
    }
}