// swiftlint:disable:this file_name
//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

#if canImport(UIKit)

import Nimble
import Nodes
import UIKit
import XCTest

@MainActor // swiftlint:disable:next type_name
final class UITabBarControllerTabBarControllableTests: XCTestCase {

    func testSet() {
        let tabBarController: TabBarControllable = givenTabBarController()
        expect(tabBarController.viewControllers).to(beEmpty())
        let viewControllers: [UIViewController] = [UIViewController(), UIViewController(), UIViewController()]
        expect(viewControllers).to(notBeNilAndElementsToDeallocateAfterTest())
        tabBarController.viewControllers = viewControllers
        expect(tabBarController.viewControllers?.map { $0._asUIViewController() }) == viewControllers
    }

    func testAsUITabBarController() {
        let tabBarController: TabBarControllable = givenTabBarController()
        expect(tabBarController._asUITabBarController()) === tabBarController
        expect(tabBarController._asUITabBarController()).to(beAKindOf(UITabBarController.self))
    }

    private func givenTabBarController() -> UITabBarController {
        let tabBarController: UITabBarController = .init()
        expect(tabBarController).to(notBeNilAndToDeallocateAfterTest())
        return tabBarController
    }
}

#endif
