//
//  Copyright © 2020 Tinder (Match Group, LLC)
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UINavigationController: NavigationControllable {

    /// An array of the ``ViewControllable`` instances on the navigation stack.
    public var viewControllers: [ViewControllable] {
        get { children }
        set { setViewControllers(newValue, animated: false) }
    }

    /// Sets the ``ViewControllable`` instances on the navigation stack.
    ///
    /// - Parameters:
    ///   - viewControllers: The array of ``ViewControllable`` instances to set on the navigation stack.
    ///   - animated: A Boolean value specifying whether changes to the navigation stack are animated.
    public func setViewControllers(_ viewControllers: [ViewControllable], animated: Bool) {
        setViewControllers(viewControllers.map { $0._asUIViewController() }, animated: animated)
    }

    /// Pushes a ``ViewControllable`` instance onto the navigation stack.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to push on to the navigation stack.
    ///   - animated: A Boolean value specifying whether the navigation stack transition is animated.
    public func pushViewController(_ viewController: ViewControllable, animated: Bool) {
        let viewController: UIViewController = viewController._asUIViewController()
        pushViewController(viewController, animated: animated)
    }

    /// Pops a ``ViewControllable`` instance from the navigation stack.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to pop from the navigation stack.
    ///   - animated: A Boolean value specifying whether the navigation stack transition is animated.
    public func popViewController(_ viewController: ViewControllable, animated: Bool) {
        let viewController: UIViewController = viewController._asUIViewController()
        guard viewController === topViewController
        else { return }
        popViewController(animated: animated)
    }

    // swiftlint:disable identifier_name

    /// Returns `self` as a ``UINavigationController``.
    ///
    /// - Returns: The `self` instance as a ``UINavigationController``.
    public func _asUINavigationController() -> UINavigationController {
        self
    }

    // swiftlint:enable identifier_name
}

#endif
