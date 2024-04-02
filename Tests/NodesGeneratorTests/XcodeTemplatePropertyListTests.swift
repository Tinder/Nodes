//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

@testable import NodesGenerator
import XCTest

final class XcodeTemplatePropertyListTests: XCTestCase {

    private typealias PropertyList = XcodeTemplatePropertyList
    private typealias Option = PropertyList.Option

    func testEncode() throws {
        // swiftlint:disable:next redundant_type_annotation
        let flag: Bool = false
        // swiftlint:disable:next closure_body_length
        let plist: XcodeTemplatePropertyList = .init(sortOrder: 23) {
            Option(identifier: "identifier-1",
                   name: "name-1",
                   description: "description-1",
                   default: "default-1")
            [
                Option(identifier: "identifier-2",
                       name: "name-2",
                       description: "description-2"),
                Option(identifier: "identifier-3",
                       name: "name-3",
                       description: "description-3")
            ]
            if flag {
                Option(identifier: "identifier-4",
                       name: "name-4",
                       description: "description-4")
            }
            if flag {
                Option(identifier: "identifier-5",
                       name: "name-5",
                       description: "description-5")
            } else {
                Option(identifier: "identifier-6",
                       name: "name-6",
                       description: "description-6")
            }
            if !flag {
                Option(identifier: "identifier-7",
                       name: "name-7",
                       description: "description-7")
            } else {
                Option(identifier: "identifier-8",
                       name: "name-7",
                       description: "description-8")
            }
            for index in 9...11 {
                Option(identifier: "identifier-\(index)",
                       name: "name-\(index)",
                       description: "description-\(index)")
            }
            if #available(macOS 13.4, *) {
                Option(identifier: "identifier-12",
                       name: "name-12",
                       description: "description-12")
            }
        }
        let xml: String = try .init(decoding: plist.encode(), as: UTF8.self)
        assertSnapshot(of: xml, as: .lines)
    }
}
