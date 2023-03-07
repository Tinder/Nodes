//
//  UIWindow+WindowViewControllable.swift
//  Nodes
//
//  Created by Caio Fonseca on 2/23/22.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UIWindow: WindowViewControllable {

    /// Presents a ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to present.
    public func present(_ viewController: ViewControllable) {
        rootViewController = viewController._asUIViewController()
        makeKeyAndVisible()
    }
}

#endif
