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

    /// Provides the parent Node with access to the View so it can be presented.
    /// - Returns: The ``ViewControllable`` instance made available to the parent `Flow` instance for display or
    /// presentation.
    func getViewController() -> ViewControllable
}
