//
//  ViewControllableFlow.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

/// @mockable
public protocol ViewControllableFlow: Flow {

    var viewControllable: ViewControllable { get }
}
