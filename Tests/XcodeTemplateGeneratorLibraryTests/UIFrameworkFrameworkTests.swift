//
//  UIFrameworkFrameworkTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 11/14/22.
//

import Nimble
import SnapshotTesting
@testable import XcodeTemplateGeneratorLibrary
import XCTest
import Yams

internal final class UIFrameworkFrameworkTests: XCTestCase {

    internal func testAppKit() {
        let appKit: UIFramework.Framework = .appKit
        expect(appKit.kind) == .appKit
        expect(appKit.name) == "AppKit"
        expect(appKit.import) == "AppKit"
        expect(appKit.viewControllerType) == "NSViewController"
    }

    internal func testUIKit() {
        let uiKit: UIFramework.Framework = .uiKit
        expect(uiKit.kind) == .uiKit
        expect(uiKit.name) == "UIKit"
        expect(uiKit.import) == "UIKit"
        expect(uiKit.viewControllerType) == "UIViewController"
    }

    internal func testSwiftUI() {
        let swiftUI: UIFramework.Framework = .swiftUI
        expect(swiftUI.kind) == .swiftUI
        expect(swiftUI.name) == "SwiftUI"
        expect(swiftUI.import) == "SwiftUI"
        expect(swiftUI.viewControllerType) == "AbstractViewHostingController"
    }

    internal func testCustom() {
        let custom: UIFramework.Framework = .custom(name: "<name>",
                                                    import: "<import>",
                                                    viewControllerType: "<viewControllerType>")
        expect(custom.kind) == .custom
        expect(custom.name) == "<name>"
        expect(custom.import) == "<import>"
        expect(custom.viewControllerType) == "<viewControllerType>"
    }

    internal func testFrameworkInitFromDecoder() throws {
        let frameworks: [UIFramework.Framework] = [
            .appKit,
            .uiKit,
            .swiftUI,
            .custom(name: "<name>", import: "<import>", viewControllerType: "<viewControllerType>")
        ]
        try frameworks.forEach {
            let data: Data = .init(givenYAML(for: $0).utf8)
            let framework: UIFramework.Framework = try YAMLDecoder().decode(UIFramework.Framework.self, from: data)
            expect(framework) == $0
        }
    }

    internal func testFrameworkInitFromDecoderThrowsError() throws {
        let inputs: [(errorName: String, yaml: String)] = [
            ("Custom-Must-Be-Object", "Custom"),
            ("Unsupported-Framework", "AnyUnsupportedFrameworkName"),
            ("Single-Key-Expected", "custom:\ncustom:\n"),
            ("Expected-String", "[]")
        ]
        try inputs.forEach { input in
            let data: Data = .init(input.yaml.utf8)
            try expect(YAMLDecoder().decode(UIFramework.Framework.self, from: data)).to(throwError { error in
                assertSnapshot(matching: error, as: .dump, named: input.errorName)
            })
        }
    }

    private func givenYAML(for framework: UIFramework.Framework) -> String {
        switch framework {
        case .appKit, .uiKit, .swiftUI:
            return framework.name
        case let .custom(name, `import`, viewControllerType):
            return """
                custom:
                  name: \(name)
                  import: \(`import`)
                  viewControllerType: \(viewControllerType)
                """
        }
    }
}
