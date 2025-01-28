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

extension UIWindow: WindowViewControllable {

    /// Sets a ``ViewControllable`` instance as the root view controller of the window and then shows the window and
    /// makes it the key window.
    ///
    /// - Parameter rootViewController: The ``ViewControllable`` instance to set as the root view controller.
    public func makeKeyAndVisible(rootViewController viewController: ViewControllable) {
        rootViewController = viewController._asUIViewController()
        makeKeyAndVisible()
    }
}

#endif
