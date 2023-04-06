//
//  UIFrameworkKindTests.swift
//  NodesXcodeTemplatesGeneratorTests
//
//  Created by Garric Nahapetian on 11/14/22.
//

import Nimble
import NodesXcodeTemplatesGenerator
import XCTest

final class UIFrameworkKindTests: XCTestCase {

    func testAllCases() {
        expect(UIFramework.Kind.allCases) == [.appKit, .uiKit, .swiftUI, .custom]
    }

    func testRawValues() {
        expect(UIFramework.Kind.allCases.map(\.rawValue)) == ["AppKit", "UIKit", "SwiftUI", "Custom"]
    }
}
