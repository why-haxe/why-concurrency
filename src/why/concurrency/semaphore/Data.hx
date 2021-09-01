package why.concurrency.semaphore;

using Lambda;
using tink.CoreApi;

class Data<T> extends Base<T> implements Semaphore<T> {
	public final max:Int;
	
	final pool:List<T>;

	public function new(pool:Array<T>) {
		this.pool = pool.list();
		this.max = pool.length;
	}
	
	function get():Option<T> {
		return switch pool.pop() {
			case null: None; // TODO: this will fail if we have Array<Noise> because `Noise == null`?
			case v: Some(v);
		}
	}
	
	function put(data:T) {
		pool.add(data);
	}
}
