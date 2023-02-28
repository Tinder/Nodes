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
    /// - Parameter viewControllable: The ``ViewControllable`` instance to present.
    public func present(_ viewControllable: ViewControllable) {
        rootViewController = viewControllable._asUIViewController()
        makeKeyAndVisible()
    }
}

#endif
