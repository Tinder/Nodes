// swiftlint:disable:this file_name
//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

#if canImport(UIKit)

import Nimble
import Nodes
import UIKit
import XCTest

final class UIWindowViewControllableTests: XCTestCase {

    func testPresent() {
        let testWindow: UIWindow = givenWindow()
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

    private func givenWindow() -> UIWindow {
        let window: UIWindow = .init()
        expect(window).to(notBeNilAndToDeallocateAfterTest())
        return window
    }
}

#endif
