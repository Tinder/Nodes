// swiftlint:disable:this file_name
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

final class UIViewControllerViewControllableTests: XCTestCase {

    private class TestViewController: UIViewController {

        override var presentedViewController: UIViewController? {
            presentedViewControllers.last
        }

        private(set) var presentedViewControllers: [UIViewController] = []

        private(set) var dismissCallCount: Int = 0
        private(set) var willMoveCallCount: Int = 0
        private(set) var didMoveCallCount: Int = 0

        // swiftlint:disable unused_parameter

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

        // swiftlint:enable unused_parameter

        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            willMoveCallCount += 1
        }

        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            didMoveCallCount += 1
        }
    }

    @MainActor
    func testWithModalStyleCover() {
        let viewController: UIViewController = givenViewController()
        expect(viewController.modalPresentationStyle) == UIModalPresentationStyle.none
        expect(viewController.isModalInPresentation) == false
        viewController.withModalStyle(.cover())
        expect(viewController.modalPresentationStyle) == .fullScreen
        expect(viewController.isModalInPresentation) == true
    }

    @MainActor
    func testWithModalStyleOverlay() {
        let viewController: UIViewController = givenViewController()
        expect(viewController.modalPresentationStyle) == UIModalPresentationStyle.none
        expect(viewController.isModalInPresentation) == false
        viewController.withModalStyle(.overlay())
        expect(viewController.modalPresentationStyle) == .overFullScreen
        expect(viewController.isModalInPresentation) == true
    }

    @MainActor
    func testWithModalStylePageSheet() {
        let viewController: UIViewController = givenViewController()
        expect(viewController.modalPresentationStyle) == UIModalPresentationStyle.none
        expect(viewController.isModalInPresentation) == false
        viewController.withModalStyle(.sheet(style: .page))
        expect(viewController.modalPresentationStyle) == .pageSheet
        expect(viewController.isModalInPresentation) == true
    }

    @MainActor
    func testWithModalStyleFormSheet() {
        let viewController: UIViewController = givenViewController()
        expect(viewController.modalPresentationStyle) == UIModalPresentationStyle.none
        expect(viewController.isModalInPresentation) == false
        viewController.withModalStyle(.sheet(style: .form))
        expect(viewController.modalPresentationStyle) == .formSheet
        expect(viewController.isModalInPresentation) == true
    }

    @MainActor
    func testWithModalStyleCustom() {
        let viewController: UIViewController = givenViewController()
        expect(viewController.modalPresentationStyle) == UIModalPresentationStyle.none
        expect(viewController.isModalInPresentation) == false
        viewController.withModalStyle(.custom())
        expect(viewController.modalPresentationStyle) == UIModalPresentationStyle.none
        expect(viewController.isModalInPresentation) == true
    }

    @MainActor
    func testWithModalStyleWithAdditionalConfiguration() {
        let viewController: UIViewController = givenViewController()
        var additionalConfiguration1: [UIViewController] = []
        var additionalConfiguration2: [UIViewController] = []
        var additionalConfiguration3: [UIViewController] = []
        let modalStyle: ModalStyle = .custom()
            .withAdditionalConfiguration { additionalConfiguration1.append($0._asUIViewController()) }
            .withAdditionalConfiguration { additionalConfiguration2.append($0._asUIViewController()) }
            .withAdditionalConfiguration { additionalConfiguration3.append($0._asUIViewController()) }
        viewController.withModalStyle(modalStyle)
        expect(additionalConfiguration1) == [viewController]
        expect(additionalConfiguration2) == [viewController]
        expect(additionalConfiguration3) == [viewController]
        viewController.withModalStyle(modalStyle)
        expect(additionalConfiguration1.count) == 2
        expect(additionalConfiguration2.count) == 2
        expect(additionalConfiguration3.count) == 2
    }

    @MainActor
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

    @MainActor
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

    @MainActor
    func testAsUIViewController() {
        let viewController: ViewControllable = givenViewController()
        expect(viewController._asUIViewController()) === viewController
        expect(viewController._asUIViewController()).to(beAKindOf(UIViewController.self))
    }

    @MainActor
    private func givenViewController() -> TestViewController {
        let viewController: TestViewController = .init()
        viewController.modalPresentationStyle = .none
        expect(viewController).to(notBeNilAndToDeallocateAfterTest())
        return viewController
    }
}

#endif
