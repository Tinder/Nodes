//
//  UIFrameworkDefaultsTests.swift
//  NodesXcodeTemplatesGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 11/14/22.
//

@testable import NodesXcodeTemplatesGeneratorLibrary
import SnapshotTesting
import XCTest

final class UIFrameworkDefaultsTests: XCTestCase {

    func testDefaults() {
        let framework: UIFramework.Framework = .custom(name: "<uiFrameworkName>",
                                                       import: "<uiFrameworkImport>",
                                                       viewControllerType: "<viewControllerType>",
                                                       viewControllerSuperParameters: "<viewControllerSuperParameters>")
        assertSnapshot(matching: UIFramework.makeDefaultFramework(for: framework), as: .dump)
    }

    func testDefaultsAppKit() {
        assertSnapshot(matching: UIFramework.makeDefaultAppKitFramework(), as: .dump)
    }

    func testDefaultsUIKit() {
        assertSnapshot(matching: UIFramework.makeDefaultUIKitFramework(), as: .dump)
    }

    func testDefaultsSwiftUI() {
        assertSnapshot(matching: UIFramework.makeDefaultSwiftUIFramework(), as: .dump)
    }
}
