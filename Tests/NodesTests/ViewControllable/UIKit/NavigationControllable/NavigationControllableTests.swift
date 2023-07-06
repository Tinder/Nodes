//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

#if canImport(UIKit)

import Nimble
@testable import Nodes
import UIKit
import XCTest

final class NavigationControllableTests: XCTestCase {

    func testSet() {
        let navigationController: NavigationControllable = givenNavigationController()
        expect(navigationController.viewControllers).to(beEmpty())
        let viewControllers: [UIViewController] = [UIViewController(), UIViewController(), UIViewController()]
        expect(viewControllers).to(notBeNilAndElementsToDeallocateAfterTest())
        navigationController.viewControllers = viewControllers
        expect(navigationController.viewControllers.map { $0._asUIViewController() }) == viewControllers
    }

    func testPush() {
        let navigationController: NavigationControllable = givenNavigationController()
        expect(navigationController.viewControllers).to(beEmpty())
        let viewControllers: [UIViewController] = [UIViewController(), UIViewController(), UIViewController()]
        expect(viewControllers).to(notBeNilAndElementsToDeallocateAfterTest())
        viewControllers.forEach { navigationController.push($0, animated: false) }
        expect(navigationController.viewControllers.map { $0._asUIViewController() }) == viewControllers
    }

    func testPop() {
        let navigationController: NavigationControllable = givenNavigationController()
        let viewControllers: [UIViewController] = [UIViewController(), UIViewController(), UIViewController()]
        expect(viewControllers).to(notBeNilAndElementsToDeallocateAfterTest())
        navigationController.viewControllers = viewControllers
        navigationController.pop(viewControllers[2], animated: false)
        navigationController.pop(viewControllers[1], animated: false)
        expect(navigationController.viewControllers.map { $0._asUIViewController() }) == [viewControllers[0]]
    }

    func testAsUINavigationController() {
        let navigationController: NavigationControllable = givenNavigationController()
        expect(navigationController._asUINavigationController()) === navigationController
        expect(navigationController._asUINavigationController()).to(beAKindOf(UINavigationController.self))
    }

    private func givenNavigationController() -> UINavigationController {
        let navigationController: UINavigationController = .init()
        expect(navigationController).to(notBeNilAndToDeallocateAfterTest())
        return navigationController
    }
}

#endif
