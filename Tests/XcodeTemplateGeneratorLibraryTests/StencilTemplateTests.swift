//
//  StencilTemplateTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 12/6/22.
//

import Nimble
@testable import XcodeTemplateGeneratorLibrary
import XCTest

final class StencilTemplateTests: XCTestCase, TestFactories {

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
            .viewState,
            .worker
        ]
    }

    func testDescription() {
        StencilTemplate.allCases.forEach { stencilTemplate in
            expect("\(stencilTemplate)") == stencilTemplate.name
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
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
            case .viewState:
                expect(name) == "ViewState"
            case .worker:
                expect(name) == "Worker"
            }
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
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
            case .viewState:
                expect(filename) == "ViewState"
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
                .state,
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
            .state,
            .worker
        ]
    }

    // swiftlint:disable:next cyclomatic_complexity
    func testImports() {
        let config: Config = givenConfig()
        for stencilTemplate in StencilTemplate.allCases {
            for uiFramework in config.uiFrameworks {
                let imports: Set<String> = stencilTemplate.imports(for: uiFramework, config: config)
                let uiFrameworkImport: String
                switch uiFramework.kind {
                case .appKit:
                    uiFrameworkImport = "AppKit"
                case .uiKit:
                    uiFrameworkImport = "UIKit"
                case .swiftUI:
                    uiFrameworkImport = "SwiftUI"
                case .custom:
                    uiFrameworkImport = "<uiFrameworkImport>"
                }
                switch stencilTemplate {
                case .analytics, .flow, .state, .viewState:
                    expect(imports) == ["Nodes", "<baseImports>"]
                case .builder:
                    expect(imports) == ["Nodes", "<baseImports>", "<reactiveImports>", "<dependencyInjectionImports>"]
                case .context, .worker:
                    expect(imports) == ["Nodes", "<baseImports>", "<reactiveImports>"]
                case .viewController:
                    expect(imports) == ["Nodes", "<baseImports>", "<reactiveImports>", uiFrameworkImport]
                case .plugin, .pluginList:
                    expect(imports) == ["Nodes", "<baseImports>", "<dependencyInjectionImports>"]
                }
            }
        }
    }
}
