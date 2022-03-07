import Foundation

/**
 * Create a simple `Result` queue with 2 generic types:
 * - `ResultSuccess: Any`
 * - `ResultError: Error`
 *
 * Note: Queue should be initialized with at least one element before using `dequeue()`
 *
 * e.g.: `[.success(Contact()), .failure(.networkError), .success(Contact()), .failure(.operationFailed)]`
 */
class MockResultQueue<ResultSuccess, ResultError: Error>: MockQueue<Result<ResultSuccess, ResultError>> {
    init(_ queue: Result<ResultSuccess, ResultError>...) {
        super.init(queue)
    }
}

/**
 * Create a simple queue with an optional `Error`
 *
 * Note: Queue should be initialized with at least one element before using `dequeue()`
 *
 * e.g.: `[.networkError, nil, nil, .operationFailed]`
 */
class MockErrorQueue<ResultError: Error>: MockQueue<ResultError?> {
    init(_ queue: ResultError?...) {
        super.init(queue)
    }
}

/**
 * Should not be directly instantiated! Just a base class to manage a queue
 * Use the ones above to create queues with the proper type for mock gateways
 *
 * Create a mocked queue that should have at least one element.
 * Can be initialized with multiple elements
 *
 * methods:
 * - `enqueue(elements:)`: Add elements to queue
 * - `dequeue()`: Get the first element and remove it from queue (except for the last one)
 * - `set(elements:)`: Override the queue with new elements.
 */
class MockQueue<T> {
    private var queue: [T]

    init(_ queue: [T] = []) {
        self.queue = queue
    }

    func enqueue(_ elements: T...) {
        enqueue(elements)
    }

    func enqueue(_ elements: [T]) {
        queue.append(contentsOf: elements)
    }

    func dequeue() -> T {
        guard !queue.isEmpty else { fatalError("Queue is empty") }

        return queue.count > 1 ? queue.removeFirst() : queue[0]
    }

    func set(_ elements: T...) {
        queue.removeAll()
        enqueue(elements)
    }
}

