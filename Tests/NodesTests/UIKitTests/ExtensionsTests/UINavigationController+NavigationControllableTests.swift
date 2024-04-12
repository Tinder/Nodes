// swiftlint:disable:this file_name
//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

#if canImport(UIKit)

import Nimble
import Nodes
import UIKit
import XCTest

// swiftlint:disable:next type_name
final class UINavigationControllerNavigationControllableTests: XCTestCase {

    @MainActor
    func testSetViewControllers() {
        let navigationController: NavigationControllable = givenNavigationController()
        expect(navigationController.viewControllers).to(beEmpty())
        let viewControllers: [UIViewController] = [UIViewController(), UIViewController(), UIViewController()]
        expect(viewControllers).to(notBeNilAndElementsToDeallocateAfterTest())
        navigationController.viewControllers = viewControllers
        expect(navigationController.viewControllers.map { $0._asUIViewController() }) == viewControllers
    }

    @MainActor
    func testPushViewController() {
        let navigationController: NavigationControllable = givenNavigationController()
        expect(navigationController.viewControllers).to(beEmpty())
        let viewControllers: [UIViewController] = [UIViewController(), UIViewController(), UIViewController()]
        expect(viewControllers).to(notBeNilAndElementsToDeallocateAfterTest())
        viewControllers.forEach { navigationController.pushViewController($0, animated: false) }
        expect(navigationController.viewControllers.map { $0._asUIViewController() }) == viewControllers
    }

    @MainActor
    func testPopViewController() {
        let navigationController: NavigationControllable = givenNavigationController()
        let viewControllers: [UIViewController] = [UIViewController(), UIViewController(), UIViewController()]
        expect(viewControllers).to(notBeNilAndElementsToDeallocateAfterTest())
        navigationController.viewControllers = viewControllers
        expect(navigationController.popViewController(viewControllers[2], animated: false)) != nil
        expect(navigationController.popViewController(viewControllers[1], animated: false)) != nil
        expect(navigationController.viewControllers.map { $0._asUIViewController() }) == [viewControllers[0]]
    }

    @MainActor
    func testAsUINavigationController() {
        let navigationController: NavigationControllable = givenNavigationController()
        expect(navigationController._asUINavigationController()) === navigationController
        expect(navigationController._asUINavigationController()).to(beAKindOf(UINavigationController.self))
    }

    @MainActor
    private func givenNavigationController() -> UINavigationController {
        let navigationController: UINavigationController = .init()
        expect(navigationController).to(notBeNilAndToDeallocateAfterTest())
        return navigationController
    }
}

#endif
