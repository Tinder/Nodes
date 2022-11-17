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

final class UIFrameworkTests: XCTestCase {

    func testInitWithAppKit() {
        let defaults: UIFramework = .DefaultAppKitFramework.make()
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

    func testInitWithUIKit() {
        let defaults: UIFramework = .DefaultUIKitFramework.make()
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

    func testInitWithSwiftUI() {
        let defaults: UIFramework = .DefaultSwiftUIFramework.make()
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

    func testInitWithCustom() {
        let framework: UIFramework.Framework = .custom(name: "<name>",
                                                       import: "<import>",
                                                       viewControllerType: "<viewControllerType>")
        let custom: UIFramework = .init(framework: framework)
        expect(custom.kind) == framework.kind
        expect(custom.name) == framework.name
        expect(custom.import) == framework.import
        expect(custom.viewControllerType) == framework.viewControllerType
        let defaults: UIFramework = .DefaultFramework.make(for: framework)
        expect(custom.viewControllerSuperParameters) == defaults.viewControllerSuperParameters
        expect(custom.viewControllerProperties) == defaults.viewControllerProperties
        expect(custom.viewControllerMethods) == defaults.viewControllerMethods
        expect(custom.viewControllerMethodsForRootNode) == defaults.viewControllerMethodsForRootNode
    }

    func testDecoding() throws {
        try UIFramework.Kind
            .allCases
            .map(givenYAML)
            .map(\.utf8)
            .map(Data.init(_:))
            .map { try YAMLDecoder().decode(UIFramework.self, from: $0) }
            .forEach {
                assertSnapshot(matching: $0, as: .dump, named: $0.kind.rawValue)
            }
    }

    func testDecodingWithDefaults() throws {
        try UIFramework.Kind
            .allCases
            .map(givenMinimalYAML)
            .map(\.utf8)
            .map(Data.init(_:))
            .map { try YAMLDecoder().decode(UIFramework.self, from: $0) }
            .forEach {
                assertSnapshot(matching: $0, as: .dump, named: $0.kind.rawValue)
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
