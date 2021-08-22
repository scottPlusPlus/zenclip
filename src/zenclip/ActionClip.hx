package zenclip;

class ActionClip extends BaseClip {

    private var _action:Void->Void;

    public function new(action:Void->Void){
        super();
        _action = action;
    }

    private override function doPlay() {
        _action();
        complete();
    }
}