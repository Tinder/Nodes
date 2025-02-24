//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

/**
 * ``WorkerController`` is used internally (within Nodes' source code) enabling each `Context` instance to manage
 * a collection of `Worker` instances.
 *
 * > Important: Consider ``WorkerController`` to be a private type and avoid its use within application code.
 */
public final class WorkerController {

    /// The array of `Worker` instances managed by the ``WorkerController``.
    public private(set) var workers: [Worker] = []

    /// Initializes a new ``WorkerController`` instance to manage a collection of `Worker` instances.
    ///
    /// - Parameter workers: The array of `Worker` instances to be managed by the ``WorkerController``.
    public init(workers: [Worker]) {
        self.workers = workers
    }

    /// Starts all `Worker` instances in the `workers` array.
    public func startWorkers() {
        workers.forEach { $0.start() }
    }

    /// Stops all `Worker` instances in the `workers` array.
    public func stopWorkers() {
        workers.forEach { $0.stop() }
    }

    // swiftlint:disable unused_parameter

    /// Returns the first `Worker` instance of the given `type`, if any exist, in the `workers` array.
    ///
    /// - Parameter type: The type of the `Worker` instance to return.
    ///
    /// - Returns: The first `Worker` instance of the given `type` in the `workers` array, or `nil` if none exist.
    public func firstWorker<T>(ofType type: T.Type) -> T? {
        workers.first { $0 is T } as? T
    }

    /// Executes the given closure with the first `Worker` instance of the given `type`, if any exist,
    /// in the `workers` array.
    ///
    /// - Parameters:
    ///   - type: The type of the `Worker` instance with which to execute the closure.
    ///   - perform: The closure to execute.
    ///
    ///     The closure has the following arguments:
    ///     | Name   | Description                        |
    ///     | ------ | ---------------------------------- |
    ///     | worker | The `Worker` instance of type `T`. |
    ///
    ///     The closure returns `Void` and throws.
    public func withFirstWorker<T>(ofType type: T.Type, perform: (_ worker: T) throws -> Void) rethrows {
        guard let worker: T = firstWorker(ofType: type)
        else { return }
        try perform(worker)
    }

    /// Returns an array of the `Worker` instances of the given `type` existing in the `workers` array.
    ///
    /// - Parameter type: The type of the `Worker` instances to return.
    ///
    /// - Returns: The `Worker` instances of the given `type`.
    public func workers<T>(ofType type: T.Type) -> [T] {
        workers.compactMap { $0 as? T }
    }

    // swiftlint:enable unused_parameter

    /// Executes the given closure with each `Worker` instance of the given `type`, if any exist,
    /// in the `workers` array.
    ///
    /// - Parameters:
    ///   - type: The type of the `Worker` instances with which to execute the closure.
    ///   - perform: The closure to execute.
    ///
    ///     The closure has the following arguments:
    ///     | Name   | Description                        |
    ///     | ------ | ---------------------------------- |
    ///     | worker | The `Worker` instance of type `T`. |
    ///
    ///     The closure returns `Void` and throws.
    public func withWorkers<T>(ofType type: T.Type, perform: (_ worker: T) throws -> Void) rethrows {
        try workers(ofType: type).forEach(perform)
    }

    #if DEBUG

    deinit {
        for worker: Worker in workers {
            if worker.isWorking {
                assertionFailure("""
                    Lifecycle Violation: Expected `Worker` instance to stop before `WorkerController` is deallocated
                    """)
            }
            LeakDetector.detect(worker)
        }
    }

    #endif
}
