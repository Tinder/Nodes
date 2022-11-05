//
//  StencilTemplateTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 11/4/22.
//

import SnapshotTesting
import XcodeTemplateGeneratorLibrary
import XCTest

internal final class StencilTemplateTests: XCTestCase {

    internal func testRawValue() {
        assertSnapshot(matching: StencilTemplate.allCases.map(\.rawValue), as: .dump)
    }

    internal func testAllCases() {
        assertSnapshot(matching: StencilTemplate.allCases, as: .dump)
    }
}
