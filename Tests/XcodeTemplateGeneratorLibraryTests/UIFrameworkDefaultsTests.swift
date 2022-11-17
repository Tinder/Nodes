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

final class UIFrameworkDefaultsTests: XCTestCase {

    func testDefaults() {
        let framework: UIFramework.Framework = .custom(name: "<name>",
                                                       import: "<import>",
                                                       viewControllerType: "<viewControllerType>")
        assertSnapshot(matching: UIFramework.Defaults().makeUIFramework(for: framework), as: .dump)
    }

    func testDefaultsAppKit() {
        assertSnapshot(matching: UIFramework.DefaultsAppKit().makeUIFramework(), as: .dump)
    }

    func testDefaultsUIKit() {
        assertSnapshot(matching: UIFramework.DefaultsUIKit().makeUIFramework(), as: .dump)
    }

    func testDefaultsSwiftUI() {
        assertSnapshot(matching: UIFramework.DefaultsSwiftUI().makeUIFramework(), as: .dump)
    }
}
