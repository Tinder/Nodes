// swiftlint:disable:this file_name
//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

#if canImport(UIKit) && !os(watchOS)

/**
 * The interface used for injecting a window into a `Flow` instance to limit the available API,
 * to avoid the use of UI frameworks within the `Flow` instance and to facilitate testing.
 */
/// @mockable
@preconcurrency
@MainActor
public protocol WindowViewControllable: AnyObject {

    /// Sets a ``ViewControllable`` instance as the root view controller of the window and then shows the window and
    /// makes it the key window.
    ///
    /// - Parameter rootViewController: The ``ViewControllable`` instance to set as the root view controller.
    func makeKeyAndVisible(rootViewController viewController: ViewControllable)
}

#endif
