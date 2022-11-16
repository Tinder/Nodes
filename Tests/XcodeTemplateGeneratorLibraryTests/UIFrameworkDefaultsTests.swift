//
//  UIFrameworkDefaultsTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 11/14/22.
//

import Nimble
import SnapshotTesting
@testable import XcodeTemplateGeneratorLibrary
import XCTest

internal final class UIFrameworkDefaultsTests: XCTestCase {

    internal func testDefaults() {
        let framework: UIFramework.Framework = .custom(name: "", import: "", viewControllerType: "")
        let uiFramework: UIFramework = .Defaults().makeUIFramework(for: framework)
        expect(uiFramework.viewControllerSuperParameters) == ""
        expect(uiFramework.viewControllerProperties) == ""
        expect(uiFramework.viewControllerMethods) == ""
        expect(uiFramework.viewControllerMethodsForRootNode) == ""
    }

    internal func testDefaultsAppKit() {
        assertSnapshot(matching: UIFramework.DefaultsAppKit().makeUIFramework(), as: .dump)
    }

    internal func testDefaultsUIKit() {
        assertSnapshot(matching: UIFramework.DefaultsUIKit().makeUIFramework(), as: .dump)
    }

    internal func testDefaultsSwiftUI() {
        assertSnapshot(matching: UIFramework.DefaultsSwiftUI().makeUIFramework(), as: .dump)
    }
}
