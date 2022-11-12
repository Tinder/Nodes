//
//  ConfigTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Christopher Fuller on 6/3/21.
//

import Nimble
import SnapshotTesting
@testable import XcodeTemplateGeneratorLibrary
import XCTest

import Yams

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

    func testFoo() throws {
        let foo = XcodeTemplates.Config()
        let bar = try YAMLEncoder().encode(foo)
        print(bar)
    }

    func testEncoding() throws {
        let yaml: String = """
            uiFrameworks:
            - framework: UIKit
              viewControllerSuperParameters: ''
              viewControllerProperties: ''
              viewControllerMethods: ''
              viewControllerMethodsForRootNode: ''
            - framework:
                custom:
                  name: CommandLine
                  import: ''
                  viewControllerType: ''
              viewControllerSuperParameters: ''
              viewControllerProperties: ''
              viewControllerMethods: ''
              viewControllerMethodsForRootNode: ''
            """
        let config = try YAMLDecoder().decode(Config.self, from: Data(yaml.utf8))
        dump(config.uiFrameworks)
    }

    private func givenConfig() -> String {
        """
        uiFrameworks:
          - uiKit:
              options:
                viewControllerMethods: viewControllerMethods
                viewControllerMethodsForRootNode: viewControllerMethodsForRootNode
                viewControllerProperties: viewControllerProperties
                viewControllerSuperParameters: viewControllerSuperParameters
          - swiftUI:
              options:
                viewControllerMethods: viewControllerMethods
                viewControllerMethodsForRootNode: viewControllerMethodsForRootNode
                viewControllerProperties: viewControllerProperties
                viewControllerSuperParameters: viewControllerSuperParameters
        isViewInjectedNodeEnabled: true
        fileHeader: fileHeader
        baseImports:
          - baseImports-1
          - baseImports-2
        diGraphImports:
          - diGraphImports-1
          - diGraphImports-2
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
        viewControllableType: viewControllableType
        viewControllableFlowType: viewControllableFlowType
        viewControllerUpdateComment: viewControllerUpdateComment
        viewStatePublisher: viewStatePublisher
        viewStateOperators: viewStateOperators
        publisherType: publisherType
        publisherFailureType: publisherFailureType
        cancellableType: cancellableType
        """
    }


}
