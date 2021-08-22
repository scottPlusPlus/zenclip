package test.zenclip;

import utest.Assert;
import zenclip.*;

class ActionClipTest extends utest.Test {

    public function testPlayCompletes(){
        var count = 0;
        var f = function(){
            count++;
        }
        var clip = new ActionClip(f);
        clip.play();
        Assert.equals(1, count);
        Assert.equals(State.Completed, clip.state);
    }
}