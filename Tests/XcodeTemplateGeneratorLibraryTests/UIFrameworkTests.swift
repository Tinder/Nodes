//
//  UIFrameworkTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 11/14/22.
//

import SnapshotTesting
@testable import XcodeTemplateGeneratorLibrary
import XCTest
import Yams

internal final class UIFrameworkTests: XCTestCase {

    internal func testInitWithFramework() {
        let frameworks: [UIFramework.Framework] = [
            .appKit,
            .uiKit,
            .swiftUI,
            .custom(name: "Custom", import: "<import>", viewControllerType: "<viewControllerType>")
        ]
        frameworks
            .map(UIFramework.init)
            .forEach {
                assertSnapshot(matching: $0, as: .dump, named: $0.name)
            }
    }

    internal func testInitFromDecoderWithYaml() throws {
        try UIFramework.Kind.allCases.forEach {
            let data: Data = .init(givenUIFrameworkYaml(for: $0).utf8)
            let uiFramework: UIFramework = try YAMLDecoder().decode(UIFramework.self, from: data)
            assertSnapshot(matching: uiFramework, as: .dump, named: $0.rawValue)
        }
    }

    internal func testInitFromDecoderWithDefaults() throws {
        try UIFramework.Kind.allCases.forEach {
            let data: Data = .init(givenEmptyUIFrameworkYaml(for: $0).utf8)
            let uiFramework: UIFramework = try YAMLDecoder().decode(UIFramework.self, from: data)
            assertSnapshot(matching: uiFramework, as: .dump, named: $0.rawValue)
        }
    }

    internal func testComputedProperties() {
        let frameworks: [UIFramework.Framework] = [
            .appKit,
            .uiKit,
            .swiftUI,
            .custom(name: "Custom", import: "<import>", viewControllerType: "<viewControllerType>")
        ]
        frameworks
            .map(UIFramework.init)
            .forEach {
                assertSnapshot(
                    matching: ($0.kind, $0.name, $0.import, $0.viewControllerType), as: .dump, named: $0.name
                )
            }
    }

    private func givenUIFrameworkYaml(for kind: UIFramework.Kind) -> String {
        switch kind {
        case .appKit, .uiKit, .swiftUI:
            return """
                framework: \(kind.rawValue)
                viewControllerSuperParameters: <viewControllerSuperParameters>
                viewControllerProperties: <viewControllerProperties>
                viewControllerMethods: <viewControllerMethods>
                viewControllerMethodsForRootNode: <viewControllerMethodsForRootNode>
                """
        case .custom:
            return """
                framework:
                  custom:
                    name: <name>
                    import: <import>
                    viewControllerType: <viewControllerType>
                viewControllerSuperParameters: <viewControllerSuperParameters>
                viewControllerProperties: <viewControllerProperties>
                viewControllerMethods: <viewControllerMethods>
                viewControllerMethodsForRootNode: <viewControllerMethodsForRootNode>
                """
        }
    }

    private func givenEmptyUIFrameworkYaml(for kind: UIFramework.Kind) -> String {
        switch kind {
        case .appKit, .uiKit, .swiftUI:
            return "framework: \(kind.rawValue)"
        case .custom:
            return """
            framework:
              custom:
                viewControllerType: <viewControllerType>
            """
        }
    }
}
