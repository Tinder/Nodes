//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
import NodesXcodeTemplatesGenerator
import SnapshotTesting
import XCTest

final class ConfigTests: XCTestCase, TestFactories {

    private typealias Config = XcodeTemplates.Config

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
        let config: XcodeTemplates.Config = givenConfig()
        try UIFramework.Kind
            .allCases
            .forEach { expect(try config.uiFramework(for: $0).kind) == $0 }
    }

    func testUIFrameworkForKindIsNotDefined() throws {
        var config: XcodeTemplates.Config = .init()
        config.uiFrameworks = []
        try UIFramework.Kind
            .allCases
            .forEach { kind in
                expect(try config.uiFramework(for: kind))
                    .to(throwError(errorType: XcodeTemplates.Config.ConfigError.self) { error in
                        expect(error) == .uiFrameworkNotDefined(kind: kind)
                    })
            }
    }

    private func givenConfig() -> String {
        """
        uiFrameworks:
          - framework: AppKit
            viewControllerProperties: <viewControllerProperties-AppKit>
            viewControllerMethods: <viewControllerMethods-AppKit>
            viewControllerMethodsForRootNode: <viewControllerMethodsForRootNode-AppKit>
          - framework: UIKit
            viewControllerProperties: <viewControllerProperties-UIKit>
            viewControllerMethods: <viewControllerMethods-UIKit>
            viewControllerMethodsForRootNode: <viewControllerMethodsForRootNode-UIKit>
          - framework: SwiftUI
            viewControllerProperties: <viewControllerProperties-SwiftUI>
            viewControllerMethods: <viewControllerMethods-SwiftUI>
            viewControllerMethodsForRootNode: <viewControllerMethodsForRootNode-SwiftUI>
          - framework:
              custom:
                name: <uiFrameworkName>
                import: <uiFrameworkImport>
                viewControllerType: <viewControllerType>
                viewControllerSuperParameters: <viewControllerSuperParameters>
            viewControllerProperties: <viewControllerProperties-Custom>
            viewControllerMethods: <viewControllerMethods-Custom>
            viewControllerMethodsForRootNode: <viewControllerMethodsForRootNode-Custom>
        isViewInjectedTemplateEnabled: true
        fileHeader: <fileHeader>
        baseImports:
          - <baseImports-1>
          - <baseImports-2>
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
        viewControllerUpdateComment: <viewControllerUpdateComment>
        viewStateOperators: <viewStateOperators>
        viewStateTransform: <viewStateTransform>
        publisherType: <publisherType>
        publisherFailureType: <publisherFailureType>
        cancellableType: <cancellableType>
        """
    }
}
