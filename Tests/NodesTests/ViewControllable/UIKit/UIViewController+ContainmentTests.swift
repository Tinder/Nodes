// swiftlint:disable:this file_name
//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

#if canImport(UIKit)

import Nimble
@testable import Nodes
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

    func testContainLayout() {
        let viewController: TestViewController = givenViewController()
        let child: TestViewController = givenViewController()
        expect(child.willMoveCallCount) == 0
        expect(child.didMoveCallCount) == 0
        expect(viewController.children).to(beEmpty())
        expect(viewController.view.subviews).to(beEmpty())
        var expectedConstraints: [NSLayoutConstraint] = []
        let actualConstraints: [NSLayoutConstraint] = viewController.contain(child) { view, subview in
            expect(view) === viewController.view
            expect(subview) === child.view
            let constraints: [NSLayoutConstraint] = [
                subview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                subview.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
            expectedConstraints = constraints
            NSLayoutConstraint.activate(constraints)
            return constraints
        }
        expect(actualConstraints) == expectedConstraints
        expect(child.view.translatesAutoresizingMaskIntoConstraints) == false
        expect(child.willMoveCallCount) == 1
        expect(child.didMoveCallCount) == 1
        expect(viewController.children) == [child]
        expect(viewController.view.subviews).to(contain(child.view))
    }

    func testContainInView() {
        let viewController: TestViewController = givenViewController()
        let child: TestViewController = givenViewController()
        expect(child.willMoveCallCount) == 0
        expect(child.didMoveCallCount) == 0
        expect(viewController.children).to(beEmpty())
        expect(viewController.view.subviews).to(beEmpty())
        viewController.contain(child, in: viewController.view)
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

    private func givenViewController() -> TestViewController {
        let viewController: TestViewController = .init()
        expect(viewController).to(notBeNilAndToDeallocateAfterTest())
        return viewController
    }
}

#endif
