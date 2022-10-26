//
//  ConfigTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Christopher Fuller on 6/3/21.
//

import Nimble
import SnapshotTesting
import XcodeTemplateGeneratorLibrary
import XCTest

final class ConfigTests: XCTestCase {

    private typealias Config = XcodeTemplates.Config

    func testConfig() throws {
        let fileSystem: MockFileSystem = .init()
        let url: URL = .init(fileURLWithPath: "/")
        fileSystem.contents[url] = Data(givenConfig().utf8)
        let config: Config = try .init(at: url.path, using: fileSystem)
        assertSnapshot(matching: config, as: .dump)
    }

    func testEmptyConfig() throws {
        let fileSystem: MockFileSystem = .init()
        let url: URL = .init(fileURLWithPath: "/")
        fileSystem.contents[url] = Data("".utf8)
        let config: Config = try .init(at: url.path, using: fileSystem)
        expect(config) == Config()
        assertSnapshot(matching: config, as: .dump)
    }

    func testDefaultConfig() throws {
        assertSnapshot(matching: Config(), as: .dump)
    }

    private func givenConfig() -> String {
        """
        includedTemplates:
          - includedTemplates-1
          - includedTemplates-2
        fileHeader: fileHeader
        analyticsImports:
          - analyticsImports-1
          - analyticsImports-2
        builderImports:
          - builderImports-1
          - builderImports-2
        contextImports:
          - contextImports-1
          - contextImports-2
        flowImports:
          - flowImports-1
          - flowImports-2
        pluginImports:
          - pluginImports-1
          - pluginImports-2
        pluginListImports:
          - pluginListImports-1
          - pluginListImports-2
        stateImports:
          - stateImports-1
          - stateImports-2
        viewControllerImports:
          - viewControllerImports-1
          - viewControllerImports-2
        viewControllerImportsSwiftUI:
          - viewControllerImportsSwiftUI-1
          - viewControllerImportsSwiftUI-2
        viewStateImports:
          - viewStateImports-1
          - viewStateImports-2
        workerImports:
          - workerImports-1
          - workerImports-2
        dependencies:
          - name: dependencies-name-1
            type: dependencies-type-1
          - name: dependencies-name-2
            type: dependencies-type-2
        flowProperties:
          - name: flowProperties-name-1
            type: flowProperties-type-1
          - name: flowProperties-name-2
            type: flowProperties-type-2
        viewControllerType: viewControllerType
        viewControllableType: viewControllableType
        viewControllableFlowType: viewControllableFlowType
        viewControllerAvailabilityAttribute: viewControllerAvailabilityAttribute
        viewControllerAvailabilityAttributeSwiftUI: viewControllerAvailabilityAttributeSwiftUI
        viewControllerSuperParameters: viewControllerSuperParameters
        viewControllerProperties: viewControllerProperties
        viewControllerPropertiesSwiftUI: viewControllerPropertiesSwiftUI
        viewControllerMethods: viewControllerMethods
        viewControllerMethodsSwiftUI: viewControllerMethodsSwiftUI
        rootViewControllerMethods: rootViewControllerMethods
        rootViewControllerMethodsSwiftUI: rootViewControllerMethodsSwiftUI
        viewControllerUpdateComment: viewControllerUpdateComment
        viewStatePublisher: viewStatePublisher
        viewStateOperators: viewStateOperators
        publisherType: publisherType
        publisherFailureType: publisherFailureType
        cancellableType: cancellableType
        """
    }
}
