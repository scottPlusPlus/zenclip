package test.zenclip;


import utest.ITest;
import utest.Assert;
import zenclip.*;
import test.TestClock;

class ClipBagTest extends utest.Test {

    public function testCompletionControl(){

        var child = new BaseClip();
        var bag = new ClipBag();
        bag.completeOnEmpty = false;

        bag.add(child);
        bag.play();
        Assert.equals(State.Playing, bag.state);
        Assert.equals(State.Playing, child.state);

        child.complete();
        Assert.equals(State.Completed, child.state);
        Assert.equals(State.Playing, bag.state);

        bag.completeOnEmpty = true;
        child = new BaseClip();
        bag.add(child);
        Assert.equals(State.Playing, child.state);

        child.complete();
        Assert.equals(State.Completed, child.state);
        Assert.equals(State.Completed, bag.state);
    }
}