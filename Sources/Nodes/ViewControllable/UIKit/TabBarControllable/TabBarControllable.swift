//
//  TabBarControllable.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

/**
 * A protocol that inherits from ``ViewControllable`` used for injecting a tab bar user interface into
 * a `Flow` instance to limit the available API, to avoid the use of UI frameworks within the `Flow`
 * instance and to facilitate testing.
 */
public protocol TabBarControllable: ViewControllable {

    /// An array of the ``ViewControllable`` instances displayed in the tab bar interface.
    var viewControllers: [ViewControllable]? { get set } // swiftlint:disable:this discouraged_optional_collection

    /// Sets the ``ViewControllable`` instances displayed in the tab bar interface.
    ///
    /// - Parameters:
    ///   - viewControllers: The array of ``ViewControllable`` instances to display in the tab bar interface.
    ///   - animated: A Boolean value specifying whether changes to the tab bar interface are animated.
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
