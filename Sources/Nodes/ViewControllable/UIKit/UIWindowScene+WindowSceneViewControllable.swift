//
//  UIWindowScene+WindowSceneViewControllable.swift
//  Nodes
//
//  Created by Caio Fonseca on 2/23/22.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UIWindowScene: WindowSceneViewControllable {

    /// Creates a ``WindowViewControllable`` instance and associates it with the scene.
    ///
    /// - Returns: The ``WindowViewControllable`` instance created.
    public func makeWindow() -> WindowViewControllable {
        UIWindow(windowScene: self)
    }
}

#endif
