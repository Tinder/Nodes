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
    private func givenWindow() -> UIWindow {
        let window: UIWindow = .init()
        expect(window).to(notBeNilAndToDeallocateAfterTest())
        return window
    }

    @MainActor
    private func givenViewController() -> UIViewController {
        let viewController: UIViewController = .init()
        expect(viewController).to(notBeNilAndToDeallocateAfterTest())
        return viewController
    }
}

#endif
