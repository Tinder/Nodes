//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UIWindow: WindowViewControllable {

    /// Presents a ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to present.
    public func present(_ viewController: ViewControllable) {
        rootViewController = viewController._asUIViewController()
        makeKeyAndVisible()
    }
}

#endif
