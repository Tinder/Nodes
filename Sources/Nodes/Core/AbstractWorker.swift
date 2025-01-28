//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

/**
 * Nodes’ ``_BaseWorker`` base class.
 *
 * > Note: This abstract class should never be instantiated directly and must therefore always be subclassed.
 */
open class _BaseWorker: Worker { // swiftlint:disable:this type_name

    /// A Boolean value indicating whether the `Worker` instance has started working.
    public private(set) var isWorking: Bool = false

    /// Initializes a ``_BaseWorker`` instance.
    public init() {}

    /// Subclasses may override this method to define logic to be performed when the `Worker` starts.
    ///
    /// - Note: The default implementation of this method does nothing.
    ///
    /// - Important: This method should never be called directly.
    ///   The ``_BaseWorker`` instance calls this method internally.
    open func didStart() {}

    /// Subclasses may override this method to define logic to be performed when the `Worker` stops.
    ///
    /// - Note: The default implementation of this method does nothing.
    ///
    /// - Important: This method should never be called directly.
    ///   The ``_BaseWorker`` instance calls this method internally.
    open func willStop() {}

    /// Subclasses may override this method to reset state when the `Worker` stops.
    ///
    /// This method is prefixed with an underscore to indicate that it should only be overridden
    /// in another abstract class definition.
    ///
    /// - Note: The default implementation of this method does nothing.
    ///
    /// - Important: This method should never be called directly.
    ///   The ``_BaseWorker`` instance calls this method internally.
    open func _reset() {} // swiftlint:disable:this identifier_name

    /// Starts the `Worker` instance.
    ///
    /// - Important: This method should never be called directly within application code.
    ///   This method is called internally within the framework code.
    public final func start() {
        guard !isWorking
        else { return }
        isWorking = true
        didStart()
    }

    /// Stops the `Worker` instance.
    ///
    /// - Important: This method should never be called directly within application code.
    ///   This method is called internally within the framework code.
    public final func stop() {
        guard isWorking
        else { return }
        willStop()
        _reset()
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
open class AbstractWorker<CancellableType: Cancellable>: _BaseWorker {

    /// The set of `CancellableType` instances.
    public var cancellables: Set<CancellableType> = .init()

    /// Subclasses may not override this method.
    ///
    /// - Important: This method should never be called directly.
    ///   The ``AbstractWorker`` instance calls this method internally.
    override public final func _reset() {
        cancellables.forEach { cancellable in
            cancellable.cancel()
            LeakDetector.detect(cancellable)
        }
        cancellables.removeAll()
    }
}
