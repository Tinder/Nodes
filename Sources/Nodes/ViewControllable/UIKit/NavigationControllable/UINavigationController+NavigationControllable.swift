//
//  UINavigationController+NavigationControllable.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UINavigationController: NavigationControllable {

    /// An array of the ``ViewControllable`` instances on the navigation stack.
    public var viewControllers: [ViewControllable] {
        get { children }
        set { set(newValue, animated: false) }
    }

    /// Sets the ``ViewControllable`` instances on the navigation stack.
    ///
    /// - Parameters:
    ///   - viewControllers: The array of ``ViewControllable`` instances to set on the navigation stack.
    ///   - animated: A Boolean value specifying whether changes to the navigation stack are animated.
    public func set(_ viewControllers: [ViewControllable], animated: Bool) {
        setViewControllers(viewControllers.map { $0._asUIViewController() }, animated: animated)
    }

    /// Pushes a ``ViewControllable`` instance onto the navigation stack.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to push on to the navigation stack.
    ///   - animated: A Boolean value specifying whether the navigation stack transition is animated.
    public func push(_ viewController: ViewControllable, animated: Bool) {
        let viewController: UIViewController = viewController._asUIViewController()
        pushViewController(viewController, animated: animated)
    }

    /// Pops a ``ViewControllable`` instance from the navigation stack.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to pop from the navigation stack.
    ///   - animated: A Boolean value specifying whether the navigation stack transition is animated.
    public func pop(_ viewController: ViewControllable, animated: Bool) {
        let viewController: UIViewController = viewController._asUIViewController()
        guard viewController === topViewController
        else { return }
        popViewController(animated: animated)
    }

    /// Returns `self` as a ``UINavigationController``.
    ///
    /// - Returns: The `self` instance as a ``UINavigationController``.
    public func _asUINavigationController() -> UINavigationController { // swiftlint:disable:this identifier_name
        self
    }
}

#endif
