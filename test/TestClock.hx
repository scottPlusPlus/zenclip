package test;

import tink.CoreApi.SignalTrigger;

class TestClock {

    public function new(){
        this.time = 0;
        this.signalTime = new SignalTrigger<Float>();
        this.signalDelta = new SignalTrigger<Float>();
    }

    public var time: Float;
    public var signalTime:SignalTrigger<Float>;
    public var signalDelta:SignalTrigger<Float>;

    public function getTime():Float{
        return time;
    }

    public function tick(newTime:Float){
        signalDelta.trigger(newTime - time);
        time = newTime;
        signalTime.trigger(time);
    }

    public function tickTo(targetTime:Float, interval:Float=0.1){
        if (targetTime < time){
            throw('tickTo targetTime should be bigger than currentTime');
        }
        tickFor(targetTime - time, interval);
    }

    public function tickFor(duration:Float, interval:Float=0.1) {
        var target = time + duration;
        while(duration > interval) {
            duration -= interval;
            tick(time + interval);
        }
        //end the clock on the actual time, avoid float-drift
        tick(target);
    }
}