//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

#if canImport(UIKit)

import Nimble
@testable import Nodes
import UIKit
import XCTest

final class ViewControllableTests: XCTestCase {

    private class TestViewController: UIViewController {

        override var presentedViewController: UIViewController? {
            presentedViewControllers.last
        }

        private(set) var presentedViewControllers: [UIViewController] = []

        private(set) var dismissCallCount: Int = 0

        override func present(
            _ viewControllerToPresent: UIViewController,
            animated flag: Bool,
            completion: (() -> Void)? = nil
        ) {
            presentedViewControllers.append(viewControllerToPresent)
        }

        override func dismiss(
            animated flag: Bool,
            completion: (() -> Void)? = nil
        ) {
            dismissCallCount += 1
        }
    }

    func testPresentation() {
        let testViewController: TestViewController = givenViewController()
        let child: TestViewController = givenViewController()
        expect(testViewController.presentedViewControllers).to(beEmpty())
        testViewController.present(child, withModalStyle: .cover(), animated: false)
        expect(testViewController.presentedViewControllers) == [child]
        expect(testViewController.dismissCallCount) == 0
        testViewController.dismiss(child, animated: false)
        expect(testViewController.dismissCallCount) == 1
    }

    private func givenViewController() -> TestViewController {
        let viewController: TestViewController = .init()
        expect(viewController).to(notBeNilAndToDeallocateAfterTest())
        return viewController
    }
}

#endif
