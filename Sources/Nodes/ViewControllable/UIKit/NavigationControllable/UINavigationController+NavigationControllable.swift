//
//  Created by Christopher Fuller on 10/3/20.
//  Copyright © 2020 Tinder. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UINavigationController: NavigationControllable {

    public var viewControllers: [ViewControllable] {
        get { children }
        set { set(newValue, animated: false) }
    }

    public func set(_ viewControllers: [ViewControllable], animated: Bool) {
        setViewControllers(viewControllers.map { $0._asUIViewController() }, animated: animated)
    }

    public func push(_ viewController: ViewControllable, animated: Bool) {
        let viewController: UIViewController = viewController._asUIViewController()
        pushViewController(viewController, animated: animated)
    }

    public func pop(_ viewController: ViewControllable, animated: Bool) {
        let viewController: UIViewController = viewController._asUIViewController()
        guard viewController === topViewController
        else { return }
        popViewController(animated: animated)
    }

    public func _asUINavigationController() -> UINavigationController {
        self
    }
}

#endif
