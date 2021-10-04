package zenclip;

class LazyClip extends ClipBag {
	private var _createChildClip:Void->IClip;

	public function new(f:Void->IClip) {
		super();
		_createChildClip = f;
		completeOnEmpty = true;
	}

	private override function doPlay() {
		var childClip = _createChildClip();
		add(childClip);
		for (c in _children) {
			c.play();
		}
	}
}
