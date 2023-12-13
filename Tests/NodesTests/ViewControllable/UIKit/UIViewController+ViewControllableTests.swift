// swiftlint:disable:this file_name
//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

#if canImport(UIKit)

import Nimble
import Nodes
import UIKit
import XCTest

final class UIViewControllerViewControllableTests: XCTestCase {

    private class TestViewController: UIViewController {

        override var presentedViewController: UIViewController? {
            presentedViewControllers.last
        }

        private(set) var presentedViewControllers: [UIViewController] = []

        private(set) var dismissCallCount: Int = 0
        private(set) var willMoveCallCount: Int = 0
        private(set) var didMoveCallCount: Int = 0

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

        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            willMoveCallCount += 1
        }

        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            didMoveCallCount += 1
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

    func testContainment() {
        let viewController: TestViewController = givenViewController()
        let child: TestViewController = givenViewController()
        expect(child.willMoveCallCount) == 0
        expect(child.didMoveCallCount) == 0
        expect(viewController.children).to(beEmpty())
        expect(viewController.view.subviews).to(beEmpty())
        viewController.contain(child)
        expect(child.willMoveCallCount) == 1
        expect(child.didMoveCallCount) == 1
        expect(viewController.children) == [child]
        expect(viewController.view.subviews).to(contain(child.view))
        viewController.uncontain(child)
        expect(child.willMoveCallCount) == 2
        expect(child.didMoveCallCount) == 2
        expect(viewController.children).to(beEmpty())
        expect(viewController.view.subviews).to(beEmpty())
    }

    func testAsUIViewController() {
        let viewController: ViewControllable = givenViewController()
        expect(viewController._asUIViewController()) === viewController
        expect(viewController._asUIViewController()).to(beAKindOf(UIViewController.self))
    }

    private func givenViewController() -> TestViewController {
        let viewController: TestViewController = .init()
        expect(viewController).to(notBeNilAndToDeallocateAfterTest())
        return viewController
    }
}

#endif
