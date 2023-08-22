//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

#if canImport(UIKit)

import Nimble
@testable import Nodes
import UIKit
import XCTest

final class UIViewControllerViewControllableTests: XCTestCase {

    private class TestViewController: UIViewController {}

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
