package why.concurrency.semaphore;

using tink.CoreApi;

class Unlimited implements Semaphore<Noise> {
	public final max:Int = 2147483647; // TODO: rethink about this
	
	final v = new Pair(Noise, (null:CallbackLink));
	
	public function new() {}
	
	public function acquire():Future<Pair<Noise, CallbackLink>> {
		return Future.sync(v);
	}
	public function tryAcquire():Option<Pair<Noise, CallbackLink>> {
		return Some(v);
	}
	public function run<V>(f:Noise->Promise<V>):Promise<V> {
		return f(Noise);
	}
}