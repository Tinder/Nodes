//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
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
