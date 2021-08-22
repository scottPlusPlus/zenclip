package zenclip;

import tink.core.Promise;
import tink.core.Promise.Next;
import tink.core.Error;

class IClipX {

    public static function completedPromise(c:IClip):Promise<IClip> {
        if (c.state == Completed){
            return Promise.resolve(c);
        }
        if (c.state == Killed){
            return Promise.reject(new Error('Clip was killed and will never complete'));
        }
        var pt = new PromiseTrigger<IClip>();
        c.onComplete.handle(pt.resolve);
        c.onKill.handle(function(_){
            pt.reject(new Error('Clip was killed and will never complete'));
        });
        return pt;
    }

    public static function next<T>(c:IClip, f:Next<IClip, T>):Promise<T> {
        return c.onComplete.nextTime().next(f);
    }
}