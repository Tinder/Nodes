//
//  Copyright © 2020 Tinder (Match Group, LLC)
//

/**
 * The interface used for injecting a collection of `Worker` instances into an ``AbstractContext`` instance
 * which enables starting and stopping the `Worker` instances within the base class implementation.
 */
/// @mockable
public protocol Worker: AnyObject {

    /// A Boolean value indicating whether the `Worker` instance has started working.
    var isWorking: Bool { get }

    /// Starts the `Worker` instance.
    ///
    /// - Important: This method should never be called directly within application code.
    ///   This method is called internally within the framework code.
    func start()

    /// Stops the `Worker` instance.
    ///
    /// - Important: This method should never be called directly within application code.
    ///   This method is called internally within the framework code.
    func stop()
}

/**
 * Nodes’ ``AbstractWorker`` base class.
 *
 * > Note: This abstract class should never be instantiated directly and must therefore always be subclassed.
 *
 * ``AbstractWorker`` has the following generic parameter:
 * | Name            | Description                                                                                  |
 * | --------------- | -------------------------------------------------------------------------------------------- |
 * | CancellableType | The type supporting subscription cancellation that conforms to the ``Cancellable`` protocol. |
 */
open class AbstractWorker<CancellableType: Cancellable>: Worker {

    /// The set of `CancellableType` instances.
    public var cancellables: Set<CancellableType> = .init()

    /// A Boolean value indicating whether the `Worker` instance has started working.
    public private(set) var isWorking: Bool = false // swiftlint:disable:this redundant_type_annotation

    /// Initializes an ``AbstractWorker`` instance.
    public init() {}

    /// Subclasses may override this method to define logic to be performed when the `Worker` starts.
    ///
    /// - Note: The default implementation of this method does nothing.
    ///
    /// - Important: This method should never be called directly.
    ///   The ``AbstractWorker`` instance calls this method internally.
    open func didStart() {}

    /// Subclasses may override this method to define logic to be performed when the `Worker` stops.
    ///
    /// - Note: The default implementation of this method does nothing.
    ///
    /// - Important: This method should never be called directly.
    ///   The ``AbstractWorker`` instance calls this method internally.
    open func willStop() {}

    /// Starts the `Worker` instance.
    ///
    /// - Important: This method should never be called directly within application code.
    ///   This method is called internally within the framework code.
    public final func start() {
        guard !isWorking
        else {
            assertionFailure("Unable to start")
            return
        }
        isWorking = true
        didStart()
    }

    /// Stops the `Worker` instance.
    ///
    /// - Important: This method should never be called directly within application code.
    ///   This method is called internally within the framework code.
    public final func stop() {
        guard isWorking
        else {
            assertionFailure("Unable to stop")
            return
        }
        willStop()
        cancellables.forEach { cancellable in
            cancellable.cancel()
            LeakDetector.detect(cancellable)
        }
        cancellables.removeAll()
        isWorking = false
    }

    deinit {
        #if DEBUG
        if isWorking {
            assertionFailure("Lifecycle Violation: Expected `AbstractWorker` to stop before it is deallocated.")
        }
        #endif
    }
}
