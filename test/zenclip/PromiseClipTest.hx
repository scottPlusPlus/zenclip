package test.zenclip;

import tink.core.Noise;
import tink.core.Promise;
import utest.Assert;
import zenclip.*;

class PromiseClipTest extends utest.Test {

    public function testPlayCompletes(async:utest.Async) {
        var pt = new PromiseTrigger<Noise>();
        var f = function(){
            pt.resolve(Noise);
            return pt.asPromise();
        }
        var clip = new PromiseClip(f);
        var checker = new ClipStateChecker(clip);

        clip.onComplete.nextTime(function(_){
            Assert.equals(1, checker.state().completeCount);
            Assert.equals(State.Completed, checker.state().state);
            async.done();
            return true;
        });

        clip.play();
    }

    public function testPauseMidPromise(async:utest.Async) {
        var pt = new PromiseTrigger<Noise>();
        var f = function(){
            return pt.asPromise();
        }
        var clip = new PromiseClip(f);
        var checker = new ClipStateChecker(clip);

        clip.onComplete.nextTime(function(_){
            Assert.equals(1, checker.state().completeCount);
            Assert.equals(State.Completed, checker.state().state);
            async.done();
            return true;
        });
        clip.play();
        clip.pause();

        pt.asPromise().next(function(_){
            Assert.equals(State.Paused, checker.state().state);
            return Noise;
        }).eager();
        pt.resolve(Noise);
        clip.resume();
    }
}