package test;

import tink.core.Signal;

class SignalTester<T> {
	public var input:Array<T> = new Array<T>();

	public function new(s:Signal<T>) {
		register(s);
	}

	public function count() {
		return input.length;
	}

	private function register(s:Signal<T>) {
		s.handle(this.activate);
	}

	private function activate(x:T) {
		input.push(x);
	}
}
