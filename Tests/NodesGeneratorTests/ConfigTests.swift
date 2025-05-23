//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Codextended
import InlineSnapshotTesting
import Nimble
import NodesGenerator
import XCTest
import Yams

final class ConfigTests: XCTestCase, TestFactories {

    func testConfigErrorLocalizedDescription() {
        expect(Config.ConfigError.emptyStringNotAllowed(key: "<key>").localizedDescription) == """
            ERROR: Empty String Not Allowed [key: <key>] \
            (TIP: Omit from config for the default value to be used instead)
            """
    }

    func testConfig() throws {
        let fileSystem: FileSystemMock = .init()
        let url: URL = .init(fileURLWithPath: "/", isDirectory: true)
        fileSystem.contents[url] = Data(givenConfigYAML().utf8)
        let config: Config = try .init(at: url.path, using: fileSystem)
        assertSnapshot(of: config, as: .dump)
    }

    func testConfigWithEmptyFileContents() throws {
        let fileSystem: FileSystemMock = .init()
        let url: URL = .init(fileURLWithPath: "/", isDirectory: true)
        fileSystem.contents[url] = Data("".utf8)
        let config: Config = try .init(at: url.path, using: fileSystem)
        expect(config) == Config()
        assertSnapshot(of: config, as: .dump)
    }

    func testDecodingFromEmptyString() throws {
        let config: Config = try Data("".utf8).decoded(as: Config.self, using: YAMLDecoder())
        expect(config) == Config()
        assertSnapshot(of: config, as: .dump)
    }

    func testDecodingWithEmptyArray() throws {
        let config: Config = try Data("uiFrameworks: []".utf8).decoded(as: Config.self, using: YAMLDecoder())
        expect(config) == Config()
        assertSnapshot(of: config, as: .dump)
    }

    func testDecodingThrowsEmptyStringNotAllowedForCustomUIFramework() throws {
        let requiredKeys: [(key: String, yaml: String)] = [
            (key: "name", yaml: givenCustomUIFrameworkConfigYAML(name: "")),
            (key: "import", yaml: givenCustomUIFrameworkConfigYAML(import: "")),
            (key: "viewControllerType", yaml: givenCustomUIFrameworkConfigYAML(viewControllerType: ""))
        ]
        for (key, yaml): (String, String) in requiredKeys {
            expect(try Data(yaml.utf8).decoded(as: Config.self, using: YAMLDecoder()))
                .to(throwError(errorType: DecodingError.self) { error in
                    assertInlineSnapshot(of: error, as: .dump) {
                        """
                        ▿ DecodingError
                          ▿ dataCorrupted: Context
                            - codingPath: 0 elements
                            - debugDescription: "The given data was not valid YAML."
                            ▿ underlyingError: Optional<Error>
                              ▿ some: ConfigError
                                ▿ emptyStringNotAllowed: (1 element)
                                  - key: "\(key)"
                        """ + "\n"
                    }
                })
        }
    }

    func testDecodingThrowsEmptyStringNotAllowed() throws {
        let requiredKeys: [String] = [
            "publisherType",
            "viewControllableFlowType",
            "viewControllableType",
            "viewControllerSubscriptionsProperty",
            "viewStateEmptyFactory",
            "viewStatePropertyComment",
            "viewStatePropertyName",
            "viewStateTransform"
        ]
        for key: String in requiredKeys {
            let yaml: String = """
                \(key): ""
                """
            expect(try Data(yaml.utf8).decoded(as: Config.self, using: YAMLDecoder()))
                .to(throwError(errorType: DecodingError.self) { error in
                    assertInlineSnapshot(of: error, as: .dump) {
                        """
                        ▿ DecodingError
                          ▿ dataCorrupted: Context
                            - codingPath: 0 elements
                            - debugDescription: "The given data was not valid YAML."
                            ▿ underlyingError: Optional<Error>
                              ▿ some: ConfigError
                                ▿ emptyStringNotAllowed: (1 element)
                                  - key: "\(key)"
                        """ + "\n"
                    }
                })
        }
    }

    func testStorePrefix() {
        var config: Config = .init()
        config.isObservableStoreEnabled = false
        expect(config.storePrefix.isEmpty) == true
        config.isObservableStoreEnabled = true
        expect(config.storePrefix) == "Observable"
    }

    func testIsNimbleEnabled() {
        var config: Config = .init()
        config.baseTestImports = ["Nimble"]
        expect(config.isNimbleEnabled) == true
        config.baseTestImports = []
        expect(config.isNimbleEnabled) == false
    }

    private func givenConfigYAML() -> String {
        """
        uiFrameworks:
          - framework: AppKit
          - framework: UIKit
          - framework: UIKit (SwiftUI)
          - framework:
              custom:
                name: <uiFrameworkName>
                import: <uiFrameworkImport>
                viewControllerType: <viewControllerType>
                viewControllerSuperParameters: <viewControllerSuperParameters>
                viewControllerMethods: <viewControllerMethods>
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
        builderImports:
          - <builderImports-1>
          - <builderImports-2>
        flowImports:
          - <flowImports-1>
          - <flowImports-2>
        interfaceImports:
          - <interfaceImports-1>
          - <interfaceImports-2>
        pluginListImports:
          - <pluginListImports-1>
          - <pluginListImports-2>
        pluginListInterfaceImports:
          - <pluginListInterfaceImports-1>
          - <pluginListInterfaceImports-2>
        viewControllerImports:
          - <viewControllerImports-1>
          - <viewControllerImports-2>
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
        viewControllableFlowType: <viewControllableFlowType>
        viewControllableType: <viewControllableType>
        viewControllableMockContents: <viewControllableMockContents>
        viewControllerStaticContent: <viewControllerStaticContent>
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
        isObservableStoreEnabled: false
        isPreviewProviderEnabled: true
        isTestTemplatesGenerationEnabled: true
        isPeripheryCommentEnabled: true
        """
    }

    private func givenCustomUIFrameworkConfigYAML(
        name: String = "<uiFrameworkName>",
        import: String = "<uiFrameworkImport>",
        viewControllerType: String = "<viewControllerType>",
        viewControllerSuperParameters: String = "<viewControllerSuperParameters>",
        viewControllerMethods: String = "<viewControllerMethods>"
    ) -> String {
        """
        uiFrameworks:
          - framework:
              custom:
                name: \(name)
                import: \(`import`)
                viewControllerType: \(viewControllerType)
                viewControllerSuperParameters: \(viewControllerSuperParameters)
                viewControllerMethods: \(viewControllerMethods)
        """
    }
}
