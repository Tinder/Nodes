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

extension UIWindowScene: WindowSceneViewControllable {

    /// Creates a ``WindowViewControllable`` instance and associates it with the scene.
    ///
    /// - Returns: The ``WindowViewControllable`` instance created.
    public func makeWindow() -> WindowViewControllable {
        UIWindow(windowScene: self)
    }
}

#endif
