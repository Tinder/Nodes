//
//  StencilTemplateTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 12/6/22.
//

import Nimble
@testable import XcodeTemplateGeneratorLibrary
import XCTest

final class StencilTemplateTests: XCTestCase {

    func testVariationRawValue() {
        StencilTemplate.Variation.allCases.forEach { variation in
            switch variation {
            case .default:
                expect(variation.rawValue) == ""
            case .swiftUI:
                expect(variation.rawValue) == "-SwiftUI"
            }
        }
    }

    func testVariationForKind() {
        UIFramework.Kind.allCases.forEach { kind in
            let variation: StencilTemplate.Variation = .variation(for: kind)
            switch kind {
            case .appKit, .uiKit, .custom:
                expect(variation) == .default
            case .swiftUI:
                expect(variation) == .swiftUI
            }
        }
    }

    func testAllCases() {
        expect(StencilTemplate.allCases) == [
            .analytics,
            .builder(.default),
            .builder(.swiftUI),
            .context,
            .flow,
            .plugin,
            .pluginList,
            .state,
            .viewController(.default),
            .viewController(.swiftUI),
            .worker
        ]
    }

    func testDescription() {
        StencilTemplate.allCases.forEach { stencilTemplate in
            expect("\(stencilTemplate)") == stencilTemplate.name
        }
    }

    func testName() {
        for stencilTemplate in StencilTemplate.allCases {
            let name: String = stencilTemplate.name
            switch stencilTemplate {
            case .analytics:
                expect(name) == "Analytics"
            case .builder:
                expect(name) == "Builder"
            case .context:
                expect(name) == "Context"
            case .flow:
                expect(name) == "Flow"
            case .plugin:
                expect(name) == "Plugin"
            case .pluginList:
                expect(name) == "PluginList"
            case .state:
                expect(name) == "State"
            case .viewController:
                expect(name) == "ViewController"
            case .worker:
                expect(name) == "Worker"
            }
        }
    }

    func testFilename() {
        for stencilTemplate in StencilTemplate.allCases {
            let filename: String = stencilTemplate.filename
            switch stencilTemplate {
            case .analytics:
                expect(filename) == "Analytics"
            case let .builder(variation):
                expect(filename) == "Builder\(variation == .swiftUI ? "-SwiftUI" : "")"
            case .context:
                expect(filename) == "Context"
            case .flow:
                expect(filename) == "Flow"
            case .plugin:
                expect(filename) == "Plugin"
            case .pluginList:
                expect(filename) == "PluginList"
            case .state:
                expect(filename) == "State"
            case let .viewController(variation):
                expect(filename) == "ViewController\(variation == .swiftUI ? "-SwiftUI" : "")"
            case .worker:
                expect(filename) == "Worker"
            }
        }
    }

    func testNodeStencils() {
        StencilTemplate.Variation.allCases.forEach { variation in
            expect(StencilTemplate.Node(for: variation).stencils) == [
                .analytics,
                .builder(variation),
                .context,
                .flow,
                .viewController(variation),
                .worker
            ]
        }
    }

    func testNodeViewInjectedStencils() {
        expect(StencilTemplate.NodeViewInjected().stencils) == [
            .analytics,
            .builder(.default),
            .context,
            .flow,
            .worker
        ]
    }
}
