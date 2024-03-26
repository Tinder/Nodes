//
//  Copyright © 2022 Tinder (Match Group, LLC)
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
