//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

/**
 * Subclasses of ``AbstractFlow`` may adopt the ``FlowRetaining`` protocol to disable child `Flow` leak detection.
 *
 * > Important: Extremely limit the use of this protocol to only where it is absolutely unavoidable.
 */
public protocol FlowRetaining: AnyObject {}

/**
 * The interface used by the ``AbstractFlow`` instance methods for attaching and detaching a child `Flow` instance.
 */
/// @mockable
@preconcurrency
@MainActor
public protocol Flow: AnyObject {

    #if DEBUG

    var tree: Node { get }

    #endif

    /// A Boolean value indicating whether the `Flow` instance has started.
    var isStarted: Bool { get }

    /// The `Context` instance.
    ///
    /// - Important: Consider this property to be private and avoid its use within application code.
    ///   This property is used internally within the framework code.
    var _context: Context { get } // swiftlint:disable:this identifier_name

    /// Starts the `Flow` instance.
    ///
    /// - Important: This method should never be called directly within application code.
    ///   This method is called internally within the framework code.
    func start()

    /// Ends the `Flow` instance.
    ///
    /// - Important: This method should never be called directly within application code.
    ///   This method is called internally within the framework code.
    func end()
}
