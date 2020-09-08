package test;

import test.zenclip.TimelineTest;
import haxe.Json;
import utest.ui.Report;
import utest.Assert;
import utest.Async;
import utest.Runner;

class Test {

	public static function main() {
		Run();
		trace("testing zenclip");
	}

	public static function Run() {
		var runner = new Runner();

		//runner.addCase(new TimelineTest());
		runner.addCases(test.zenclip);
		Report.create(runner);
		runner.run();
	}
}
