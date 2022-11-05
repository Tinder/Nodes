//
//  StencilTemplateTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 11/4/22.
//

import SnapshotTesting
import XcodeTemplateGeneratorLibrary
import XCTest

final class StencilTemplateTests: XCTestCase {

    func testRawValue() {
        assertSnapshot(matching: StencilTemplate.allCases.map(\.rawValue), as: .dump)
    }

    func testAllCases() {
        assertSnapshot(matching: StencilTemplate.allCases, as: .dump)
    }
}
