package why.concurrency.semaphore;

using tink.CoreApi;

class Simple extends Base<Noise> implements Semaphore<Noise> {
	public final max:Int;
	
	var current:Int;

	public function new(size) {
		this.max = current = size;
	}
	
	function get():Option<Noise> {
		return if(current > 0) {
			current--; // TODO: make this thread-safe
			Some(Noise);
		} else {
			None;
		}
	}
	
	function put(data:Noise) {
		current ++;
	}
}
