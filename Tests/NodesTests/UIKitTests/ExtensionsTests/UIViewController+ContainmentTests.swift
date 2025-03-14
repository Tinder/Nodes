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

final class UIViewControllerContainmentTests: XCTestCase {

    private class TestViewController: UIViewController {

        private(set) var willMoveCallCount: Int = 0
        private(set) var didMoveCallCount: Int = 0

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
    func testContainLayout() {
        let viewController: TestViewController = givenViewController()
        let child: TestViewController = givenViewController()
        expect(child.view.translatesAutoresizingMaskIntoConstraints) == true
        expect(child.willMoveCallCount) == 0
        expect(child.didMoveCallCount) == 0
        expect(viewController.children).to(beEmpty())
        expect(viewController.view.subviews).to(beEmpty())
        let uuid: UUID = .init()
        expect(viewController.contain(child) { _, _ in uuid }) == uuid
        expect(child.view.translatesAutoresizingMaskIntoConstraints) == false
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
    func testContainInView() {
        let viewController: TestViewController = givenViewController()
        let child: TestViewController = givenViewController()
        expect(child.view.translatesAutoresizingMaskIntoConstraints) == true
        expect(child.willMoveCallCount) == 0
        expect(child.didMoveCallCount) == 0
        expect(viewController.children).to(beEmpty())
        expect(viewController.view.subviews).to(beEmpty())
        viewController.contain(child, in: viewController.view)
        expect(child.view.translatesAutoresizingMaskIntoConstraints) == false
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
    private func givenViewController() -> TestViewController {
        let viewController: TestViewController = .init()
        expect(viewController).to(notBeNilAndToDeallocateAfterTest())
        return viewController
    }
}

#endif
