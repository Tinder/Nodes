//
//  TabBarControllable.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

public protocol TabBarControllable: ViewControllable {

    // swiftlint:disable:next discouraged_optional_collection
    var viewControllers: [ViewControllable]? { get set }

    // swiftlint:disable:next discouraged_optional_collection
    func set(_ viewControllers: [ViewControllable]?, animated: Bool)

    // swiftlint:disable:next identifier_name
    func _asUITabBarController() -> UITabBarController
}

#endif
