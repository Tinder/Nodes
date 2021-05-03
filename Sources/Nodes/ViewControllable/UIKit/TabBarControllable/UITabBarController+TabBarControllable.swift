//
//  UITabBarController+TabBarControllable.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UITabBarController: TabBarControllable {

    // swiftlint:disable:next discouraged_optional_collection
    public var viewControllers: [ViewControllable]? {
        get { children }
        set { set(newValue, animated: false) }
    }

    // swiftlint:disable:next discouraged_optional_collection
    public func set(_ viewControllers: [ViewControllable]?, animated: Bool) {
        setViewControllers(viewControllers?.map { $0._asUIViewController() }, animated: animated)
    }

    // swiftlint:disable:next identifier_name
    public func _asUITabBarController() -> UITabBarController {
        self
    }
}

#endif
