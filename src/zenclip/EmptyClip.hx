package zenclip;

class EmptyClip extends BaseClip {

    public function new(){
        super();
    }

    private override function doPlay() {
        complete();
    }
}