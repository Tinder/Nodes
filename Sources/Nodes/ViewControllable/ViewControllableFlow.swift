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
@MainActor
public protocol ViewControllableFlow: Flow {

    /// The ``ViewControllable`` instance made available to the parent `Flow` instance for display or presentation.
    var viewControllable: ViewControllable { get }
}
