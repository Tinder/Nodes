//
//  Copyright © 2022 Tinder (Match Group, LLC)
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
