//
//  Created by Christopher Fuller on 10/3/20.
//  Copyright © 2020 Tinder. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UITabBarController: TabBarControllable {

    public var viewControllers: [ViewControllable]? {
        get { children }
        set { set(newValue, animated: false) }
    }

    public func set(_ viewControllers: [ViewControllable]?, animated: Bool) {
        setViewControllers(viewControllers?.map { $0._asUIViewController() }, animated: animated)
    }

    public func _asUITabBarController() -> UITabBarController {
        self
    }
}

#endif
