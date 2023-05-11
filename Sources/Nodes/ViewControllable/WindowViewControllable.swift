//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

/**
 * The interface used for injecting a window into a `Flow` instance to limit the available API,
 * to avoid the use of UI frameworks within the `Flow` instance and to facilitate testing.
 */
public protocol WindowViewControllable: AnyObject {

    /// Presents a ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to present.
    func present(_ viewController: ViewControllable)
}

#endif
