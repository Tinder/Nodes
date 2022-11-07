//
//  StencilTemplateTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 11/7/22.
//

import SnapshotTesting
import XcodeTemplateGeneratorLibrary
import XCTest

internal final class StencilTemplateTests: XCTestCase {

    internal func testAllCases() {
        assertSnapshot(matching: StencilTemplate.allCases, as: .dump)
    }

    internal func testDescription() {
        assertSnapshot(matching: StencilTemplate.allCases.map(\.description), as: .dump)
    }

    internal func testFilename() {
        assertSnapshot(matching: StencilTemplate.allCases.map(\.filename), as: .dump)
    }

    internal func testOutputFilename() {
        assertSnapshot(matching: StencilTemplate.allCases.map(\.outputFilename), as: .dump)
    }

    internal func testForSwiftUIFalse() {
        assertSnapshot(matching: StencilTemplate.allCases.map { $0.forSwiftUI(false) }, as: .dump)
    }

    internal func testForSwiftUITrue() {
        assertSnapshot(matching: StencilTemplate.allCases.map { $0.forSwiftUI(true) }, as: .dump)
    }
}
