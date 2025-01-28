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

extension UITabBarController: TabBarControllable {

    /// An array of the ``ViewControllable`` instances displayed in the tab bar interface.
    public var viewControllers: [ViewControllable]? { // swiftlint:disable:this discouraged_optional_collection
        get { children }
        set { setViewControllers(newValue, animated: false) }
    }

    /// Sets the ``ViewControllable`` instances displayed in the tab bar interface.
    ///
    /// - Parameters:
    ///   - viewControllers: The array of ``ViewControllable`` instances to display in the tab bar interface.
    ///   - animated: A Boolean value specifying whether changes to the tab bar interface are animated.
    public func setViewControllers(
        _ viewControllers: [ViewControllable]?, // swiftlint:disable:this discouraged_optional_collection
        animated: Bool
    ) {
        setViewControllers(viewControllers?.map { $0._asUIViewController() }, animated: animated)
    }

    // swiftlint:disable identifier_name

    /// Returns `self` as a ``UITabBarController``.
    ///
    /// - Returns: The `self` instance as a ``UITabBarController``.
    public func _asUITabBarController() -> UITabBarController {
        self
    }

    // swiftlint:enable identifier_name
}

#endif
