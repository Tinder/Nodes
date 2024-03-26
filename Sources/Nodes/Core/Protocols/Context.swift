//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

/**
 * The interface used by an ``AbstractFlow`` instance to activate and deactivate its `Context` instance.
 */
/// @mockable
@preconcurrency
@MainActor
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
