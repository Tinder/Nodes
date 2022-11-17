//
//  UIFrameworkKindTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 11/14/22.
//

import Nimble
@testable import XcodeTemplateGeneratorLibrary
import XCTest

final class UIFrameworkKindTests: XCTestCase {

    func testAllCases() {
        expect(UIFramework.Kind.allCases) == [.appKit, .uiKit, .swiftUI, .custom]
    }

    func testRawValues() {
        expect(UIFramework.Kind.allCases.map(\.rawValue)) == ["AppKit", "UIKit", "SwiftUI", "Custom"]
    }
}
