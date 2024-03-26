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

    @MainActor
    func testMakeKeyAndVisible() {
        let testWindow: UIWindow = givenWindow()
        let testViewController: UIViewController = givenViewController()
        expect(testWindow.rootViewController) == nil
        expect(testWindow.isHidden) == true
        expect(testWindow.isKeyWindow) == false
        testWindow.makeKeyAndVisible(rootViewController: testViewController)
        expect(testWindow.rootViewController) == testViewController
        expect(testWindow.isHidden) == false
        expect(testWindow.isKeyWindow) == true
    }

    @MainActor
    private func givenViewController() -> UIViewController {
        let viewController: UIViewController = .init()
        expect(viewController).to(notBeNilAndToDeallocateAfterTest())
        return viewController
    }

    @MainActor
    private func givenWindow() -> UIWindow {
        let window: UIWindow = .init()
        expect(window).to(notBeNilAndToDeallocateAfterTest())
        return window
    }
}

#endif
