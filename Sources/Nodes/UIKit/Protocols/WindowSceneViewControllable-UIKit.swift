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

/**
 * The interface used for injecting a window scene into a `Flow` instance to limit the available API,
 * to avoid the use of UI frameworks within the `Flow` instance and to facilitate testing.
 */
/// @mockable
@preconcurrency
@MainActor
public protocol WindowSceneViewControllable: AnyObject {

    /// Creates a ``WindowViewControllable`` instance.
    ///
    /// - Returns: The ``WindowViewControllable`` instance created.
    func makeWindow() -> WindowViewControllable
}

#endif
