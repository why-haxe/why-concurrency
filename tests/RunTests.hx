package ;

import tink.unit.*;
import tink.testrunner.*;

using tink.CoreApi;

@:asserts
class RunTests {

	static function main() {
		Runner.run(TestBatch.make(new RunTests())).handle(Runner.exit);
	}
	
	function new() {}
	
	@:variant(new why.concurrency.semaphore.Data([for(i in 0...3) i]))
	@:variant(new why.concurrency.semaphore.Simple(3))
	public function acquire<T>(s:why.Semaphore<T>) {
		asserts.assert(s.max == 3);
		
		final v1 = s.tryAcquire();
		asserts.assert(v1.match(Some(_)));
		final v2 = s.tryAcquire();
		asserts.assert(v2.match(Some(_)));
		final v3 = s.tryAcquire();
		asserts.assert(v3.match(Some(_)));
		final v4 = s.tryAcquire();
		asserts.assert(v4.match(None));
		
		v1.force().b.cancel();
		final v5 = s.tryAcquire();
		asserts.assert(v5.match(Some(_)));
		final v6 = s.tryAcquire();
		asserts.assert(v6.match(None));
		
		return asserts.done();
	}
	
	public function unlimited<T>() {
		final s = new why.concurrency.semaphore.Unlimited();
		for(i in 0...100) asserts.assert(s.tryAcquire().match(Some(_)));
		return asserts.done();
	}
	
}
