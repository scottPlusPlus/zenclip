package test.zenclip;

import tink.core.Noise;
import tink.core.Promise;
import utest.Assert;
import zenclip.*;

using zenclip.IClipX;

class CompletedPromiseTest extends utest.Test {

    public function testWhenPending(async:utest.Async) {
        var clip = new BaseClip();
        var order = 0;
        clip.completedPromise().next(function(_){
            Assert.equals(1, order);
            async.done();
            return Noise;
        }).eager();
        Assert.equals(0, order);
        order = 1;
        clip.play();
        clip.complete();
    }

    public function testWhenComplete(async:utest.Async) {
        var clip = new BaseClip();
        clip.play();
        clip.complete();
        clip.completedPromise().next(function(_){
            Assert.pass();
            async.done();
            return Noise;
        }).eager();
    }

    public function testWhenKilled(async:utest.Async) {
        var clip = new BaseClip();
        clip.play();
        clip.kill();
        clip.completedPromise().eager().handle(function(o){
            Assert.isFalse(o.isSuccess());
            async.done();
            return Noise;
        });
    }
}