//
//  WindowSceneViewControllable.swift
//  Nodes
//
//  Created by Caio Fonseca on 2/23/22.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

/**
 * The interface used for injecting a user interface into a `Flow` instance to limit the available API,
 * to avoid the use of UI frameworks within the `Flow` instance and to facilitate testing.
 */
public protocol WindowSceneViewControllable: AnyObject {

    /// Creates a ``WindowViewControllable`` instance.
    /// - Returns: The ``WindowViewControllable`` instance created.
    func makeWindow() -> WindowViewControllable
}

#else

public protocol WindowSceneViewControllable: AnyObject {}

#endif
