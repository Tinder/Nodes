//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
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
