//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
import NodesXcodeTemplatesGenerator
import SnapshotTesting
import XCTest
import Yams

final class ConfigTests: XCTestCase, TestFactories {

    func testConfig() throws {
        let fileSystem: FileSystemMock = .init()
        let url: URL = .init(fileURLWithPath: "/")
        fileSystem.contents[url] = Data(givenConfig().utf8)
        let config: Config = try .init(at: url.path, using: fileSystem)
        assertSnapshot(matching: config, as: .dump)
    }

    func testEmptyConfig() throws {
        let fileSystem: FileSystemMock = .init()
        let url: URL = .init(fileURLWithPath: "/")
        fileSystem.contents[url] = Data("".utf8)
        let config: Config = try .init(at: url.path, using: fileSystem)
        expect(config) == Config()
        assertSnapshot(matching: config, as: .dump)
    }

    func testDefaultConfig() {
        assertSnapshot(matching: Config(), as: .dump)
    }

    func testUIFrameworkForKind() throws {
        let config: Config = givenConfig()
        try UIFramework.Kind
            .allCases
            .forEach { expect(try config.uiFramework(for: $0).kind) == $0 }
    }

    func testUIFrameworkForKindIsNotDefined() throws {
        var config: Config = .init()
        config.uiFrameworks = []
        try UIFramework.Kind
            .allCases
            .forEach { kind in
                expect(try config.uiFramework(for: kind))
                    .to(throwError(errorType: Config.ConfigError.self) { error in
                        expect(error) == .uiFrameworkNotDefined(kind: kind)
                        expect(error.localizedDescription) == "ERROR: UIFramework Not Defined [`kind: \(kind)`]"
                    })
            }
    }

    func testNonEmptyStringRequired() throws {
        let keys: [String] = [
            "publisherType",
            "viewControllableFlowType",
            "viewControllableType",
            "viewControllerSubscriptionsProperty",
            "viewStateEmptyFactory",
            "viewStatePropertyComment",
            "viewStatePropertyName",
            "viewStateTransform"
        ]
        for key: String in keys {
            let data: Data = .init("\(key):".utf8)
            let decoder: YAMLDecoder = .init()
            expect(try decoder.decode(Config.self, from: data)).to(throwError(errorType: DecodingError.self) { error in
                expect(error.context?.underlyingError?.localizedDescription) == """
                    ERROR: Empty String Not Allowed [`key: \(key)`] (TIP: Omit key config for default value)
                    """
            })
        }
    }

    private func givenConfig() -> String {
        """
        uiFrameworks:
          - framework: AppKit
            viewControllerProperties: <viewControllerProperties-AppKit>
            viewControllerMethods: <viewControllerMethods-AppKit>
            viewControllableMockContents: <viewControllableMockContents-AppKit>
          - framework: UIKit
            viewControllerProperties: <viewControllerProperties-UIKit>
            viewControllerMethods: <viewControllerMethods-UIKit>
            viewControllableMockContents: <viewControllableMockContents-UIKit>
          - framework: SwiftUI
            viewControllerProperties: <viewControllerProperties-SwiftUI>
            viewControllerMethods: <viewControllerMethods-SwiftUI>
            viewControllableMockContents: <viewControllableMockContents-SwiftUI>
          - framework:
              custom:
                name: <uiFrameworkName>
                import: <uiFrameworkImport>
                viewControllerType: <viewControllerType>
                viewControllerSuperParameters: <viewControllerSuperParameters>
            viewControllerProperties: <viewControllerProperties-Custom>
            viewControllerMethods: <viewControllerMethods-Custom>
            viewControllableMockContents: <viewControllableMockContents-Custom>
        fileHeader: <fileHeader>
        baseImports:
          - <baseImports-1>
          - <baseImports-2>
        baseTestImports:
          - <baseTestImports-1>
          - <baseTestImports-2>
        reactiveImports:
          - <reactiveImports-1>
          - <reactiveImports-2>
        dependencyInjectionImports:
          - <dependencyInjectionImports-1>
          - <dependencyInjectionImports-2>
        dependencies:
          - name: <dependencies-name-1>
            type: <dependencies-type-1>
          - name: <dependencies-name-2>
            type: <dependencies-type-2>
        analyticsProperties:
          - name: <analyticsProperties-name-1>
            type: <analyticsProperties-type-1>
          - name: <analyticsProperties-name-2>
            type: <analyticsProperties-type-2>
        flowProperties:
          - name: <flowProperties-name-1>
            type: <flowProperties-type-1>
          - name: <flowProperties-name-2>
            type: <flowProperties-type-2>
        viewControllableType: <viewControllableType>
        viewControllableFlowType: <viewControllableFlowType>
        viewControllerSubscriptionsProperty: <viewControllerSubscriptionsProperty>
        viewControllerUpdateComment: <viewControllerUpdateComment>
        viewStateEmptyFactory: <viewStateEmptyFactory>
        viewStateOperators: <viewStateOperators>
        viewStatePropertyComment: <viewStatePropertyComment>
        viewStatePropertyName: <viewStatePropertyName>
        viewStateTransform: <viewStateTransform>
        publisherType: <publisherType>
        publisherFailureType: <publisherFailureType>
        contextGenericTypes:
          - <contextGenericTypes-1>
          - <contextGenericTypes-2>
        workerGenericTypes:
          - <workerGenericTypes-1>
          - <workerGenericTypes-2>
        isViewInjectedTemplateEnabled: true
        isPreviewProviderEnabled: true
        isTestTemplatesGenerationEnabled: true
        isPeripheryCommentEnabled: true
        """
    }
}
