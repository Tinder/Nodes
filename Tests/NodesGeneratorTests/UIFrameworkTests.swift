//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Codextended
import Nimble
@testable import NodesGenerator
import XCTest
import Yams

final class UIFrameworkTests: XCTestCase {

    func testInitWithAppKit() {
        let expected: UIFramework = .makeDefaultAppKitFramework()
        let framework: UIFramework = .init(framework: .appKit)
        expect(framework.kind) == expected.kind
        expect(framework.name) == expected.name
        expect(framework.import) == expected.import
        expect(framework.viewControllerType) == expected.viewControllerType
        expect(framework.viewControllerSuperParameters) == expected.viewControllerSuperParameters
        expect(framework.viewControllerProperties) == expected.viewControllerProperties
        expect(framework.viewControllerMethods) == expected.viewControllerMethods
    }

    func testInitWithUIKit() {
        let expected: UIFramework = .makeDefaultUIKitFramework()
        let framework: UIFramework = .init(framework: .uiKit)
        expect(framework.kind) == expected.kind
        expect(framework.name) == expected.name
        expect(framework.import) == expected.import
        expect(framework.viewControllerType) == expected.viewControllerType
        expect(framework.viewControllerSuperParameters) == expected.viewControllerSuperParameters
        expect(framework.viewControllerProperties) == expected.viewControllerProperties
        expect(framework.viewControllerMethods) == expected.viewControllerMethods
    }

    func testInitWithSwiftUI() {
        let expected: UIFramework = .makeDefaultSwiftUIFramework()
        let framework: UIFramework = .init(framework: .swiftUI)
        expect(framework.kind) == expected.kind
        expect(framework.name) == expected.name
        expect(framework.import) == expected.import
        expect(framework.viewControllerType) == expected.viewControllerType
        expect(framework.viewControllerSuperParameters) == expected.viewControllerSuperParameters
        expect(framework.viewControllerProperties) == expected.viewControllerProperties
        expect(framework.viewControllerMethods) == expected.viewControllerMethods
    }

    func testInitWithCustom() {
        let custom: UIFramework.Framework = .custom(name: "<uiFrameworkName>",
                                                    import: "<uiFrameworkImport>",
                                                    viewControllerType: "<viewControllerType>",
                                                    viewControllerSuperParameters: "<viewControllerSuperParameters>")
        let expected: UIFramework = .makeDefaultFramework(for: custom)
        let framework: UIFramework = .init(framework: custom)
        expect(framework.kind) == expected.kind
        expect(framework.name) == expected.name
        expect(framework.import) == expected.import
        expect(framework.viewControllerType) == expected.viewControllerType
        expect(framework.viewControllerSuperParameters) == expected.viewControllerSuperParameters
        expect(framework.viewControllerProperties) == expected.viewControllerProperties
        expect(framework.viewControllerMethods) == expected.viewControllerMethods
    }

    func testDecoding() throws {
        try UIFramework.Kind
            .allCases
            .map(givenYAML)
            .map(\.utf8)
            .map(Data.init(_:))
            .map { try $0.decoded(as: UIFramework.self, using: YAMLDecoder()) }
            .forEach { assertSnapshot(of: $0, as: .dump, named: $0.kind.rawValue) }
    }

    func testDecodingWithDefaults() throws {
        try UIFramework.Kind
            .allCases
            .map(givenMinimalYAML)
            .map(\.utf8)
            .map(Data.init(_:))
            .map { try $0.decoded(as: UIFramework.self, using: YAMLDecoder()) }
            .forEach { assertSnapshot(of: $0, as: .dump, named: $0.kind.rawValue) }
    }

    private func givenYAML(for kind: UIFramework.Kind) -> String {
        switch kind {
        case .appKit, .uiKit, .swiftUI:
            return """
                framework: \(kind.rawValue)
                viewControllerProperties: <viewControllerProperties>
                viewControllerMethods: <viewControllerMethods>
                viewControllerMethodsForRootNode: <viewControllerMethodsForRootNode>
                """
        case .custom:
            return """
                framework:
                  custom:
                    name: <uiFrameworkName>
                    import: <uiFrameworkImport>
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
                    name: <uiFrameworkName>
                    import: <uiFrameworkImport>
                    viewControllerType: <viewControllerType>
                    viewControllerSuperParameters: <viewControllerSuperParameters>
                """
        }
    }
}
