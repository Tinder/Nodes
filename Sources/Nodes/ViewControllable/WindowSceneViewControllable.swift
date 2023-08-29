//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

#if canImport(UIKit) && !os(watchOS)

/**
 * The interface used for injecting a window scene into a `Flow` instance to limit the available API,
 * to avoid the use of UI frameworks within the `Flow` instance and to facilitate testing.
 */
@preconcurrency
@MainActor
public protocol WindowSceneViewControllable: AnyObject {

    /// Creates a ``WindowViewControllable`` instance.
    ///
    /// - Returns: The ``WindowViewControllable`` instance created.
    func makeWindow() -> WindowViewControllable
}

#endif
