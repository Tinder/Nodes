//
//  UIFrameworkDefaultsTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 11/14/22.
//

import SnapshotTesting
@testable import XcodeTemplateGeneratorLibrary
import XCTest

internal final class UIFrameworkDefaultsTests: XCTestCase {

    internal func testDefaults() {
        assertSnapshot(matching: UIFramework.Defaults().makeUIFramework(for: .appKit), as: .dump)
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
