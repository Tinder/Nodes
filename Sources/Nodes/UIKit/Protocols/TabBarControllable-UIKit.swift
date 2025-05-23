// swiftlint:disable:this file_name
//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

/**
 * A protocol that inherits from ``ViewControllable`` used for injecting a tab bar user interface into
 * a `Flow` instance to limit the available API, to avoid the use of UI frameworks within the `Flow`
 * instance and to facilitate testing.
 */
/// @mockable
@preconcurrency
@MainActor
public protocol TabBarControllable: ViewControllable {

    /// An array of the ``ViewControllable`` instances displayed in the tab bar interface.
    var viewControllers: [ViewControllable]? { get set } // swiftlint:disable:this discouraged_optional_collection

    /// Sets the ``ViewControllable`` instances displayed in the tab bar interface.
    ///
    /// - Parameters:
    ///   - viewControllers: The array of ``ViewControllable`` instances to display in the tab bar interface.
    ///   - animated: A Boolean value specifying whether changes to the tab bar interface are animated.
    func setViewControllers(
        _ viewControllers: [ViewControllable]?, // swiftlint:disable:this discouraged_optional_collection
        animated: Bool
    )

    // swiftlint:disable identifier_name

    /// Returns `self` as a ``UITabBarController``.
    ///
    /// - Returns: The `self` instance as a ``UITabBarController``.
    func _asUITabBarController() -> UITabBarController

    // swiftlint:enable identifier_name
}

#endif
