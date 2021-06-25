package why.concurrency.semaphore;

using tink.CoreApi;

abstract class Base<T> {
	final pending:Array<FutureTrigger<Pair<T, CallbackLink>>> = [];
	
	abstract function get():Option<T>;
	abstract function put(data:T):Void;

	public function acquire():Future<Pair<T, CallbackLink>> {
		return switch get() {
			case None:
				pending[pending.length] = Future.trigger();
			case Some(data):
				Future.sync(new Pair(data, (release.bind(data) : CallbackLink)));
		}
	}
	
	public function tryAcquire():Option<Pair<T, CallbackLink>> {
		return get().map(data -> new Pair(data, (release.bind(data) : CallbackLink)));
	}

	public function run<V>(f:T->Promise<V>):Promise<V> {
		return acquire().flatMap(pair -> {
			f(pair.a).map(outcome -> {
				pair.b.cancel();
				outcome;
			});
		});
	}

	function release(data:T) {
		switch pending.shift() {
			case null: // no one is waiting
				put(data); // put back to pool
			case trigger:
				trigger.trigger(new Pair(data, (release.bind(data) : CallbackLink)));
		}
	}
}
