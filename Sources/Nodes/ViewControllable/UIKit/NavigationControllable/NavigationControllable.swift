//
//  Copyright © 2020 Tinder (Match Group, LLC)
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

/**
 * A protocol that inherits from ``ViewControllable`` used for injecting a navigation user interface into
 * a `Flow` instance to limit the available API, to avoid the use of UI frameworks within the `Flow`
 * instance and to facilitate testing.
 */
public protocol NavigationControllable: ViewControllable {

    /// An array of the ``ViewControllable`` instances on the navigation stack.
    var viewControllers: [ViewControllable] { get set }

    /// Sets the ``ViewControllable`` instances on the navigation stack.
    ///
    /// - Parameters:
    ///   - viewControllers: The array of ``ViewControllable`` instances to set on the navigation stack.
    ///   - animated: A Boolean value specifying whether changes to the navigation stack are animated.
    func set(_ viewControllers: [ViewControllable], animated: Bool)

    /// Pushes a ``ViewControllable`` instance onto the navigation stack.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to push on to the navigation stack.
    ///   - animated: A Boolean value specifying whether the navigation stack transition is animated.
    func push(_ viewController: ViewControllable, animated: Bool)

    /// Pops a ``ViewControllable`` instance from the navigation stack.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to pop from the navigation stack.
    ///   - animated: A Boolean value specifying whether the navigation stack transition is animated.
    func pop(_ viewController: ViewControllable, animated: Bool)

    // swiftlint:disable identifier_name

    /// Returns `self` as a ``UINavigationController``.
    ///
    /// - Returns: The `self` instance as a ``UINavigationController``.
    func _asUINavigationController() -> UINavigationController

    // swiftlint:enable identifier_name
}

#endif
