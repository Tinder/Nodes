//
//  XcodeTemplatePropertyListTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Christopher Fuller on 6/1/21.
//

import SnapshotTesting
@testable import XcodeTemplateGeneratorLibrary
import XCTest

final class XcodeTemplatePropertyListTests: XCTestCase {

    private typealias PropertyList = XcodeTemplatePropertyList
    private typealias Option = PropertyList.Option

    func testEncode() throws {
        // swiftlint:disable:next redundant_type_annotation
        let flag: Bool = false
        // swiftlint:disable:next closure_body_length
        let plist: XcodeTemplatePropertyList = .init(description: "description", sortOrder: 23) {
            Option(identifier: "identifier-1",
                   name: "name-1",
                   description: "description-1",
                   default: "default-1")
            if flag {
                Option(identifier: "identifier-2",
                       name: "name-2",
                       description: "description-2")
            }
            if flag {
                Option(identifier: "identifier-3",
                       name: "name-3",
                       description: "description-3")
            } else {
                Option(identifier: "identifier-4",
                       name: "name-4",
                       description: "description-4")
            }
            if !flag {
                Option(identifier: "identifier-5",
                       name: "name-5",
                       description: "description-5")
            } else {
                Option(identifier: "identifier-6",
                       name: "name-6",
                       description: "description-6")
            }
            for index in 7...9 {
                Option(identifier: "identifier-\(index)",
                       name: "name-\(index)",
                       description: "description-\(index)")
            }
        }
        let xml: String = try .init(decoding: plist.encode(), as: UTF8.self)
        assertSnapshot(matching: xml, as: .lines)
    }
}
