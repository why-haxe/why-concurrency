package why;

using tink.CoreApi;

interface Semaphore<T> {
	final max:Int;
	
	/**
	 * Aquire a ticket. Returns a `Future` that will be resolved:
	 * - immediately if maximum concurrency not reached
	 * - when previous tasks returns the ticket otherwise
	 * The resolved value is Pair of the associated data and a callback link.
	 * Dissolve the `CallbackLink` when the task is finished.
	 * @return Future<Pair<T, CallbackLink>>
	 */
	function acquire():Future<Pair<T, CallbackLink>>;
	
	/**
	 * Similar to acquire, but returns immediately
	 * @return Option<Pair<T, CallbackLink>>
	 */
	function tryAcquire():Option<Pair<T, CallbackLink>>;
	
	/**
	 * Acquire a ticket, run the given task, then release the ticket
	 * @param f 
	 * @return ->Promise<T>):Promise<T>
	 */
	function run<V>(f:T->Promise<V>):Promise<V>;
}