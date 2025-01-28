//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

/**
 * A protocol that inherits from ``Flow`` and defines a ``ViewControllable`` property made available to the
 * parent `Flow` instance for display or presentation.
 */
/// @mockable
@preconcurrency
@MainActor
public protocol ViewControllableFlow: Flow {

    /// Provides the ``ViewControllable`` instance to the parent `Flow` for display or presentation.
    ///
    /// - Returns: The ``ViewControllable`` instance.
    func getViewController() -> ViewControllable
}
