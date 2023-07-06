//
//  Copyright © 2020 Tinder (Match Group, LLC)
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UITabBarController: TabBarControllable {

    /// An array of the ``ViewControllable`` instances displayed in the tab bar interface.
    public var viewControllers: [ViewControllable]? { // swiftlint:disable:this discouraged_optional_collection
        get { children }
        set { set(newValue, animated: false) }
    }

    /// Sets the ``ViewControllable`` instances displayed in the tab bar interface.
    ///
    /// - Parameters:
    ///   - viewControllers: The array of ``ViewControllable`` instances to display in the tab bar interface.
    ///   - animated: A Boolean value specifying whether changes to the tab bar interface are animated.
    public func set(
        _ viewControllers: [ViewControllable]?, // swiftlint:disable:this discouraged_optional_collection
        animated: Bool
    ) {
        setViewControllers(viewControllers?.map { $0._asUIViewController() }, animated: animated)
    }

    /// Returns `self` as a ``UITabBarController``.
    ///
    /// - Returns: The `self` instance as a ``UITabBarController``.
    public func _asUITabBarController() -> UITabBarController {  // swiftlint:disable:this identifier_name
        self
    }
}

#endif
