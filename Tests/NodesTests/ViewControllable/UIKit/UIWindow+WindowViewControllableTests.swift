// swiftlint:disable:this file_name
//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

#if canImport(UIKit)

import Nimble
@testable import Nodes
import UIKit
import XCTest

final class UIWindowViewControllableTests: XCTestCase {

    func testPresent() {
        let testWindow: UIWindow = .init()
        let testViewController: UIViewController = givenViewController()
        expect(testWindow.rootViewController) == nil
        expect(testWindow.isKeyWindow) == false
        testWindow.present(testViewController)
        expect(testWindow.rootViewController) == testViewController
        expect(testWindow.isKeyWindow) == true
    }

    private func givenViewController() -> UIViewController {
        let viewController: UIViewController = .init()
        expect(viewController).to(notBeNilAndToDeallocateAfterTest())
        return viewController
    }
}

#endif
