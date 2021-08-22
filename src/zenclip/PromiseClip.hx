package zenclip;

import tink.core.Noise;
import tink.core.Promise;

class PromiseClip extends BaseClip {

    private var _promise:Void->Promise<Noise>;
    private var _promiseReady:Bool = false;

    public function new(promise:Void->Promise<Noise>){
        super();
        _promise = promise;
    }

    private override function doPlay() {
        if (_promiseReady){
            complete();
            return;
        }
        
        var p = _promise();
        p.next(function(n){
            complete();
            _promiseReady = true;
            return Noise;
        }).eager();
    }

    private override function doResume(){
        if (_promiseReady){
            complete();
            return;
        }
    }

}