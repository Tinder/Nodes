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

    internal func testInitWithAppKit() {
        let defaults: UIFramework = .DefaultsAppKit().makeUIFramework()
        let appKit: UIFramework = .init(framework: .appKit)
        expect(appKit.kind) == defaults.kind
        expect(appKit.name) == defaults.name
        expect(appKit.import) == defaults.import
        expect(appKit.viewControllerType) == defaults.viewControllerType
        expect(appKit.viewControllerSuperParameters) == defaults.viewControllerSuperParameters
        expect(appKit.viewControllerProperties) == defaults.viewControllerProperties
        expect(appKit.viewControllerMethods) == defaults.viewControllerMethods
        expect(appKit.viewControllerMethodsForRootNode) == defaults.viewControllerMethodsForRootNode
    }

    internal func testInitWithUIKit() {
        let defaults: UIFramework = .DefaultsUIKit().makeUIFramework()
        let uiKit: UIFramework = .init(framework: .uiKit)
        expect(uiKit.kind) == defaults.kind
        expect(uiKit.name) == defaults.name
        expect(uiKit.import) == defaults.import
        expect(uiKit.viewControllerType) == defaults.viewControllerType
        expect(uiKit.viewControllerSuperParameters) == defaults.viewControllerSuperParameters
        expect(uiKit.viewControllerProperties) == defaults.viewControllerProperties
        expect(uiKit.viewControllerMethods) == defaults.viewControllerMethods
        expect(uiKit.viewControllerMethodsForRootNode) == defaults.viewControllerMethodsForRootNode
    }

    internal func testInitWithSwiftUI() {
        let defaults: UIFramework = .DefaultsSwiftUI().makeUIFramework()
        let swiftUI: UIFramework = .init(framework: .swiftUI)
        expect(swiftUI.kind) == defaults.kind
        expect(swiftUI.name) == defaults.name
        expect(swiftUI.import) == defaults.import
        expect(swiftUI.viewControllerType) == defaults.viewControllerType
        expect(swiftUI.viewControllerSuperParameters) == defaults.viewControllerSuperParameters
        expect(swiftUI.viewControllerProperties) == defaults.viewControllerProperties
        expect(swiftUI.viewControllerMethods) == defaults.viewControllerMethods
        expect(swiftUI.viewControllerMethodsForRootNode) == defaults.viewControllerMethodsForRootNode
    }

    internal func testInitWithCustom() {
        let framework: UIFramework.Framework = .custom(
            name: "<name>", import: "<import>", viewControllerType: "<viewControllerType>"
        )
        let defaults: UIFramework = .Defaults().makeUIFramework(for: framework)
        let custom: UIFramework = .init(framework: framework)
        expect(custom.kind) == defaults.kind
        expect(custom.name) == "<name>"
        expect(custom.import) == "<import>"
        expect(custom.viewControllerType) == defaults.viewControllerType
        expect(custom.viewControllerSuperParameters) == defaults.viewControllerSuperParameters
        expect(custom.viewControllerProperties) == defaults.viewControllerProperties
        expect(custom.viewControllerMethods) == defaults.viewControllerMethods
        expect(custom.viewControllerMethodsForRootNode) == defaults.viewControllerMethodsForRootNode
    }

    internal func testInitFromDecoderWithYAML() throws {
        try UIFramework.Kind.allCases.forEach {
            let data: Data = .init(givenYAML(for: $0).utf8)
            let uiFramework: UIFramework = try YAMLDecoder().decode(UIFramework.self, from: data)
            assertSnapshot(matching: uiFramework, as: .dump, named: $0.rawValue)
        }
    }

    internal func testInitFromDecoderWithYAMLUsingDefaults() throws {
        try UIFramework.Kind.allCases.forEach {
            let data: Data = .init(givenMinimalYAML(for: $0).utf8)
            let uiFramework: UIFramework = try YAMLDecoder().decode(UIFramework.self, from: data)
            assertSnapshot(matching: uiFramework, as: .dump, named: $0.rawValue)
        }
    }

    private func givenYAML(for kind: UIFramework.Kind) -> String {
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

    private func givenMinimalYAML(for kind: UIFramework.Kind) -> String {
        switch kind {
        case .appKit, .uiKit, .swiftUI:
            return "framework: \(kind.rawValue)"
        case .custom:
            return """
                framework:
                  custom:
                    name: <name>
                    import: <import>
                    viewControllerType: <viewControllerType>
                """
        }
    }
}
