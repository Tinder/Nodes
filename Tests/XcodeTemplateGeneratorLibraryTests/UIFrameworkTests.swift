//
//  UIFrameworkTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 11/14/22.
//

import Nimble
import SnapshotTesting
@testable import XcodeTemplateGeneratorLibrary
import XCTest
import Yams

internal final class UIFrameworkTests: XCTestCase {

    // MARK: UIFramework tests

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

    // MARK: UIFramework.Kind tests

    internal func testKindAllCases() {
        assertSnapshot(matching: UIFramework.Kind.allCases, as: .dump)
    }

    internal func testKindRawValues() {
        assertSnapshot(matching: UIFramework.Kind.allCases.map(\.rawValue), as: .dump)
    }

    // MARK: UIFramework.Framework tests

    internal func testFrameworkComputedProperties() {
        let frameworks: [UIFramework.Framework] = [
            .appKit,
            .uiKit,
            .swiftUI,
            .custom(name: "CustomNonNil", import: "<import>", viewControllerType: "<viewControllerType>"),
            .custom(name: nil, import: nil, viewControllerType: "<viewControllerType>")
        ]
        frameworks.forEach {
            assertSnapshot(
                matching: ($0.kind, $0.name, $0.import, $0.viewControllerType), as: .dump, named: $0.name
            )
        }
    }

    internal func testFrameworkInitFromDecoder() throws {
        let frameworks: [UIFramework.Framework] = [
            .appKit,
            .uiKit,
            .swiftUI,
            .custom(name: "Custom", import: "<import>", viewControllerType: "<viewControllerType>")
        ]
        try frameworks.forEach {
            let data: Data = .init(givenFrameworkYaml(for: $0.kind).utf8)
            let framework: UIFramework.Framework = try YAMLDecoder().decode(UIFramework.Framework.self, from: data)
            assertSnapshot(matching: framework, as: .dump, named: $0.name)
        }
    }

    internal func testFrameworkInitFromDecoderAsObject() throws {
        try UIFramework.Kind.allCases.forEach {
            let data: Data = .init(givenFrameworkYamlAsObject(for: $0).utf8)
            let framework: UIFramework.Framework = try YAMLDecoder().decode(UIFramework.Framework.self, from: data)
            assertSnapshot(matching: framework, as: .dump, named: $0.rawValue)
        }
    }

    internal func testFrameworkInitFromDecoderThrowsError() throws {
        let inputs: [(errorName: String, yaml: String)] = [
            ("Custom-Must-Be-Object", "Custom"),
            ("Unsupported-Framework", "AnyUnsupportedFrameworkName"),
            ("Single-Key-Expected", "custom:\ncustom:\n")
        ]
        try inputs.forEach { input in
            let data: Data = .init(input.yaml.utf8)
            expect(try YAMLDecoder().decode(UIFramework.Framework.self, from: data)).to(throwError { error in
                assertSnapshot(matching: error, as: .dump, named: input.errorName)
            })
        }
    }

    // MARK: Helpers

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

    private func givenFrameworkYaml(for kind: UIFramework.Kind) -> String {
        switch kind {
        case .appKit, .uiKit, .swiftUI:
            return kind.rawValue
        case .custom:
            return """
                custom:
                  name: <name>
                  import: <import>
                  viewControllerType: <viewControllerType>
                """
        }
    }

    private func givenFrameworkYamlAsObject(for kind: UIFramework.Kind) -> String {
        switch kind {
        case .appKit, .uiKit, .swiftUI:
            return "\(kind): {}\n"
        case .custom:
            return """
                custom:
                  viewControllerType: <viewControllerType>
                """
        }
    }
}
