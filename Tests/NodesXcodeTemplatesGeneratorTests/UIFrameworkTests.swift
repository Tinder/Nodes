//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesXcodeTemplatesGenerator
import SnapshotTesting
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
        expect(framework.viewControllableMockContents) == expected.viewControllableMockContents
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
        expect(framework.viewControllableMockContents) == expected.viewControllableMockContents
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
        expect(framework.viewControllableMockContents) == expected.viewControllableMockContents
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
        expect(framework.viewControllableMockContents) == expected.viewControllableMockContents
    }

    func testDecoding() throws {
        try UIFramework.Kind
            .allCases
            .map(givenYAML)
            .map(\.utf8)
            .map(Data.init(_:))
            .map { try YAMLDecoder().decode(UIFramework.self, from: $0) }
            .forEach { assertSnapshot(matching: $0, as: .dump, named: $0.kind.rawValue) }
    }

    func testDecodingWithDefaults() throws {
        try UIFramework.Kind
            .allCases
            .map(givenMinimalYAML)
            .map(\.utf8)
            .map(Data.init(_:))
            .map { try YAMLDecoder().decode(UIFramework.self, from: $0) }
            .forEach { assertSnapshot(matching: $0, as: .dump, named: $0.kind.rawValue) }
    }

    func testDecodingWithEmpty() {
        let keys: [String] = ["name", "import", "viewControllerType"]
        var yaml: String = """
            framework:
              custom:
            """
        for expectedKey: String in keys {
            yaml.append("\n    \(expectedKey): ")
            expect(try YAMLDecoder().decode(UIFramework.self, from: Data(yaml.utf8)))
                .to(throwError(errorType: DecodingError.self) { error in
                    guard case let .dataCorrupted(context) = error else {
                        XCTFail("Expected DecodingError.dataCorrupted, got \(error) instead")
                        return
                    }
                    guard case let .nonEmptyStringRequired(key) = context.underlyingError as? Config.ConfigError else {
                        let underlyingError: String = .init(describing: context.underlyingError)
                        XCTFail("Expected ConfigError.nonEmptyStringRequired, got \(underlyingError) instead")
                        return
                    }
                    expect(context.codingPath.isEmpty) == true
                    expect(context.debugDescription) == "The given data was not valid YAML."
                    expect(key) == expectedKey
                    yaml.append("<\(key)>")
                })
        }
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
