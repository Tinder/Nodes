//
//  UIFrameworkDefaultsTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 11/14/22.
//

import SnapshotTesting
@testable import XcodeTemplateGeneratorLibrary
import XCTest

final class UIFrameworkDefaultsTests: XCTestCase {

    func testDefaults() {
        let framework: UIFramework.Framework = .custom(name: "<name>",
                                                       import: "<import>",
                                                       viewControllerType: "<viewControllerType>")
        assertSnapshot(matching: UIFramework.DefaultFramework.make(for: framework), as: .dump)
    }

    func testDefaultsAppKit() {
        assertSnapshot(matching: UIFramework.DefaultAppKitFramework.make(), as: .dump)
    }

    func testDefaultsUIKit() {
        assertSnapshot(matching: UIFramework.DefaultUIKitFramework.make(), as: .dump)
    }

    func testDefaultsSwiftUI() {
        assertSnapshot(matching: UIFramework.DefaultSwiftUIFramework.make(), as: .dump)
    }
}
