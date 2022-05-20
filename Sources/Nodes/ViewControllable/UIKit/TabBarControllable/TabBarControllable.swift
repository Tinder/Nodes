//
//  TabBarControllable.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

public protocol TabBarControllable: ViewControllable {

    /// An array of the ``ViewControllable`` instances displayed in the tab bar interface.
    var viewControllers: [ViewControllable]? { get set } // swiftlint:disable:this discouraged_optional_collection

    /// Sets the ``ViewControllable`` instances displayed in the tab bar interface.
    ///
    /// - Parameters:
    ///   - viewControllers: The array of ``ViewControllable`` instances to display in the tab bar interface.
    ///   - animated: A boolean value specifying whether changes to the tab bar interface are animated or not.
    func set(
        _ viewControllers: [ViewControllable]?, // swiftlint:disable:this discouraged_optional_collection
        animated: Bool
    )

    /// Returns `self` as a ``UITabBarController``.
    ///
    /// - Returns: The `self` instance as a ``UITabBarController``.
    func _asUITabBarController() -> UITabBarController // swiftlint:disable:this identifier_name
}

#endif
