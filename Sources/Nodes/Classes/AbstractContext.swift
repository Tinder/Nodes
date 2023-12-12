//
//  Copyright © 2020 Tinder (Match Group, LLC)
//

// swiftlint:disable file_types_order period_spacing

/**
 * A Nodes application can use [Combine](https://developer.apple.com/documentation/combine), or any other
 * reactive library, by providing a type supporting subscription cancellation that conforms to Nodes'
 * ``Cancellable`` protocol.
 *
 * As an example, to use Combine with Nodes, the following protocol conformance would need to exist within
 * application code:
 *
 * ```
 * import class Combine.AnyCancellable
 * import protocol Nodes.Cancellable
 *
 * extension AnyCancellable: Cancellable {}
 * ```
 */
public protocol Cancellable: AnyObject, Hashable {

    /// Cancels the ``Cancellable`` subscription.
    func cancel()
}

/**
 * The interface used by an ``AbstractFlow`` instance to activate and deactivate its `Context` instance.
 */
/// @mockable
public protocol Context: AnyObject {

    /// A Boolean value indicating whether the `Context` instance is active.
    var isActive: Bool { get }

    /// Activates the `Context` instance.
    ///
    /// - Important: This method should never be called directly within application code.
    ///   This method is called internally within the framework code.
    func activate()

    /// Deactivates the `Context` instance.
    ///
    /// - Important: This method should never be called directly within application code.
    ///   This method is called internally within the framework code.
    func deactivate()
}

/**
 * Nodes’ ``_BaseContext`` base class.
 *
 * > Note: This abstract class should never be instantiated directly and must therefore always be subclassed.
 */
open class _BaseContext: Context { // swiftlint:disable:this type_name

    /// A Boolean value indicating whether the `Context` instance is active.
    public private(set) var isActive: Bool = false // swiftlint:disable:this redundant_type_annotation

    /// The array of `Worker` instances.
    public var workers: [Worker] {
        workerController.workers
    }

    private let workerController: WorkerController

    /// Initializes a ``_BaseContext`` instance.
    ///
    /// - Parameter workers: The array of `Worker` instances.
    public init(workers: [Worker]) {
        self.workerController = .init(workers: workers)
    }

    /// Subclasses may override this method to define logic to be performed when the `Context` activates.
    ///
    /// - Note: The default implementation of this method does nothing.
    ///
    /// - Important: This method should never be called directly.
    ///   The ``_BaseContext`` instance calls this method internally.
    open func didBecomeActive() {}

    /// Subclasses may override this method to define logic to be performed when the `Context` deactivates.
    ///
    /// - Note: The default implementation of this method does nothing.
    ///
    /// - Important: This method should never be called directly.
    ///   The ``_BaseContext`` instance calls this method internally.
    open func willResignActive() {}

    /// Subclasses may override this method to reset state when the `Context` deactivates.
    ///
    /// This method is prefixed with an underscore to indicate that it should only be overridden
    /// in another abstract class definition.
    ///
    /// - Note: The default implementation of this method does nothing.
    ///
    /// - Important: This method should never be called directly.
    ///   The ``_BaseContext`` instance calls this method internally.
    open func _reset() {} // swiftlint:disable:this identifier_name

    /// Activates the `Context` instance.
    ///
    /// - Important: This method should never be called directly within application code.
    ///   This method is called internally within the framework code.
    public final func activate() {
        guard !isActive
        else { return }
        isActive = true
        didBecomeActive()
        workerController.startWorkers()
    }

    /// Deactivates the `Context` instance.
    ///
    /// - Important: This method should never be called directly within application code.
    ///   This method is called internally within the framework code.
    public final func deactivate() {
        guard isActive
        else { return }
        workerController.stopWorkers()
        willResignActive()
        _reset()
        isActive = false
    }

    /// Returns the first `Worker` instance of the given `type`, if any exist, in the `workers` array.
    ///
    /// - Parameter type: The type of the `Worker` instance to return.
    ///
    /// - Returns: The first `Worker` instance of the given `type` in the `workers` array, or `nil` if none exist.
    public final func firstWorker<T>(ofType type: T.Type) -> T? {
        workerController.firstWorker(ofType: type)
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
    public final func withFirstWorker<T>(ofType type: T.Type, perform: (_ worker: T) throws -> Void) rethrows {
        try workerController.withFirstWorker(ofType: type, perform: perform)
    }

    /// Returns an array of the `Worker` instances of the given `type` existing in the `workers` array.
    ///
    /// - Parameter type: The type of the `Worker` instances to return.
    ///
    /// - Returns: The `Worker` instances of the given `type`.
    public final func workers<T>(ofType type: T.Type) -> [T] {
        workerController.workers(ofType: type)
    }

    /// Executes the given closure with each `Worker` instance of the given `type`, if any exist,
    /// in the `workers` array.
    ///
    /// - Parameters:
    ///   - type: The type of the `Worker` instances with which to execute the closure.
    ///   - perform: The closure to execute.
    ///
    ///   The closure has the following arguments:
    ///   | Name   | Description                        |
    ///   | ------ | ---------------------------------- |
    ///   | worker | The `Worker` instance of type `T`. |
    ///
    ///   The closure returns `Void` and throws.
    public final func withWorkers<T>(ofType type: T.Type, perform: (_ worker: T) throws -> Void) rethrows {
        try workerController.withWorkers(ofType: type, perform: perform)
    }

    deinit {
        #if DEBUG
        if isActive {
            assertionFailure("Lifecycle Violation: Expected `AbstractContext` to deactivate before it is deallocated.")
        }
        #endif
    }
}

/**
 * Nodes’ ``AbstractContext`` base class.
 *
 * > Note: This abstract class should never be instantiated directly and must therefore always be subclassed.
 *
 * ``AbstractContext`` has the following generic parameter:
 * | Name            | Description                                                                                  |
 * | --------------- | -------------------------------------------------------------------------------------------- |
 * | CancellableType | The type supporting subscription cancellation that conforms to the ``Cancellable`` protocol. |
 */
open class AbstractContext<CancellableType: Cancellable>: _BaseContext {

    /// The set of `CancellableType` instances.
    public var cancellables: Set<CancellableType> = .init()

    /// Subclasses may not override this method.
    ///
    /// - Important: This method should never be called directly.
    ///   The ``AbstractContext`` instance calls this method internally.
    override public final func _reset() {
        cancellables.forEach { cancellable in
            cancellable.cancel()
            LeakDetector.detect(cancellable)
        }
        cancellables.removeAll()
    }
}

/**
 * Nodes’ ``AbstractPresentableContext`` base class.
 *
 * > Note: This abstract class should never be instantiated directly and must therefore always be subclassed.
 *
 * ``AbstractPresentableContext`` has the following generic parameters:
 * | Name            | Description                                                                                  |
 * | --------------- | -------------------------------------------------------------------------------------------- |
 * | CancellableType | The type supporting subscription cancellation that conforms to the ``Cancellable`` protocol. |
 * | PresentableType | The type of the presentable user interface.                                                  |
 */
open class AbstractPresentableContext<CancellableType: Cancellable, PresentableType>: AbstractContext<CancellableType> {

    /// The `PresentableType` instance.
    public let presentable: PresentableType

    /// Initializes an ``AbstractPresentableContext`` instance.
    ///
    /// - Parameters:
    ///   - presentable: The `PresentableType` instance.
    ///   - workers: The array of `Worker` instances.
    public init(presentable: PresentableType, workers: [Worker]) {
        self.presentable = presentable
        super.init(workers: workers)
    }
}

// swiftlint:enable file_types_order period_spacing
