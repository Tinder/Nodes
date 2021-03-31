//
//  Created by Christopher Fuller on 10/3/20.
//  Copyright © 2020 Tinder. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

public protocol TabBarControllable: ViewControllable {

    var viewControllers: [ViewControllable]? { get set }

    func set(_ viewControllers: [ViewControllable]?, animated: Bool)

    func _asUITabBarController() -> UITabBarController
}

#endif
