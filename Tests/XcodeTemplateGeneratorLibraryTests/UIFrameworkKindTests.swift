//
//  UIFrameworkKindTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 11/14/22.
//

import SnapshotTesting
@testable import XcodeTemplateGeneratorLibrary
import XCTest

internal final class UIFrameworkKindTests: XCTestCase {

    internal func testAllCases() {
        assertSnapshot(matching: UIFramework.Kind.allCases, as: .dump)
    }

    internal func testRawValues() {
        assertSnapshot(matching: UIFramework.Kind.allCases.map(\.rawValue), as: .dump)
    }
}
