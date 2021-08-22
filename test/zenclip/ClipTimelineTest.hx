package test.zenclip;

import zenclip.ClipTimeline.Marker;
import utest.ITest;
import utest.Assert;
import zenclip.*;
import test.TestClock;

class ClipTimelineTest extends utest.Test {

    function testTimeline(){

        var testClock = new TestClock();

        var timer1to2 = new ClipStateChecker( new Timer(1, testClock.signalDelta.asSignal()));
        var timer1to3 = new ClipStateChecker( new Timer(2, testClock.signalDelta.asSignal()));
        var timer2to4 = new ClipStateChecker( new Timer(2, testClock.signalDelta.asSignal()));
        var timer5to6 = new ClipStateChecker( new Timer(1, testClock.signalDelta.asSignal()));
        var markers = new Array<ClipTimeline.Marker>();

        markers.push(new Marker(1, timer1to2.clip));
        markers.push(new Marker(1, timer1to3.clip));
        markers.push(new Marker(2, timer2to4.clip));
        markers.push(new Marker(5, timer5to6.clip));

        var timeline = new ClipTimeline(testClock.signalDelta.asSignal(), markers);
        timeline.play();

        testClock.tickTo(1.0);
        testClock.tickTo(2.0);     
        Assert.equals(State.Playing, timeline.state);
        Assert.equals(State.Completed, timer1to2.state().state);
        Assert.equals(State.Playing,  timer1to3.state().state);
        Assert.equals(State.Playing,  timer2to4.state().state);
        Assert.equals(State.Pending,  timer5to6.state().state);

        testClock.tickTo(3);
        Assert.equals(State.Playing, timeline.state);
        Assert.equals(State.Completed,  timer1to3.state().state);
        Assert.equals(State.Playing,  timer2to4.state().state);
        Assert.equals(State.Pending,  timer5to6.state().state);

        testClock.tickTo(4);
        Assert.equals(State.Playing, timeline.state);
        Assert.equals(State.Completed,  timer2to4.state().state);
        Assert.equals(State.Pending,  timer5to6.state().state);

        testClock.tickTo(5);
        Assert.equals(State.Playing, timeline.state);
        Assert.equals(State.Playing,  timer5to6.state().state);

        testClock.tickTo(6);
        Assert.equals(State.Completed, timeline.state);
        Assert.equals(State.Completed,  timer5to6.state().state);
    }

    function testPausesChildren(){
        var testClock = new TestClock();
        var timer = new Timer(1, testClock.signalDelta.asSignal());
        var markers = new Array<Marker>();
        markers.push(new Marker(1, timer));
        var timeline = new ClipTimeline(testClock.signalDelta.asSignal(), markers);
        
        testClock.tickFor(1.0);
        Assert.equals(State.Pending, timeline.state);
        Assert.equals(State.Pending, timer.state);

        timeline.play();
        testClock.tickFor(0.5);
        timeline.pause();
        testClock.tickFor(1.0);
        Assert.equals(State.Paused, timeline.state);
        Assert.equals(State.Pending, timer.state);

        timeline.resume();
        testClock.tickFor(0.5);
        Assert.equals(State.Playing, timeline.state);
        Assert.equals(State.Playing, timer.state);

        testClock.tickFor(0.5);
        timeline.pause();
        Assert.equals(State.Paused, timeline.state);
        Assert.equals(State.Paused, timer.state);
    }

}