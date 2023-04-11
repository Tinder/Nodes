//
//  ViewControllableFlow.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

/**
 * A protocol that inherits from ``Flow`` and defines a ``ViewControllable`` property made available to the
 * parent `Flow` instance for display or presentation.
 */
/// @mockable
public protocol ViewControllableFlow: Flow {

    /// Provides the ``ViewControllable`` instance to the parent `Flow` for display or presentation.
    /// - Returns: The ``ViewControllable`` instance.
    func getViewController() -> ViewControllable
}
