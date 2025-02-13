//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

#if canImport(UIKit)

import Nimble
import Nodes
import UIKit
import XCTest

final class NavigationControllerTests: XCTestCase {

    @MainActor
    func testPopViewControllers() {

        let rootViewController: UIViewController = .init()
        let navigationController: NavigationController = .init(rootViewController: rootViewController)

        expect(rootViewController).to(notBeNilAndToDeallocateAfterTest())
        expect(navigationController).to(notBeNilAndToDeallocateAfterTest())

        var viewControllers: [UIViewController] = []
        expect(viewControllers).to(notBeNilAndElementsToDeallocateAfterTest())

        expect(navigationController.delegate) == nil
        navigationController.onPopViewControllers { viewControllers += $0 }
        expect(navigationController.delegate) === navigationController

        let viewController1: UIViewController = .init()
        let viewController2: UIViewController = .init()

        expect(viewController1).to(notBeNilAndToDeallocateAfterTest())
        expect(viewController2).to(notBeNilAndToDeallocateAfterTest())

        navigationController.viewControllers = [rootViewController, viewController1, viewController2]
        navigationController.navigationController(navigationController, didShow: viewController1, animated: false)
        navigationController.navigationController(navigationController, didShow: viewController2, animated: false)
        navigationController.viewControllers = [rootViewController]
        navigationController.navigationController(navigationController, didShow: rootViewController, animated: false)

        expect(viewControllers) == [viewController1, viewController2]

        navigationController.onPopViewControllers(didPopViewControllers: nil)
        expect(navigationController.delegate) == nil
    }
}

#endif
