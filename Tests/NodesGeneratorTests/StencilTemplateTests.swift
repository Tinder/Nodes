//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesGenerator
import XCTest

final class StencilTemplateTests: XCTestCase, TestFactories {

    func testVariationRawValue() {
        StencilTemplate.Variation.allCases.forEach { variation in
            switch variation {
            case .default:
                expect(variation.rawValue).to(beEmpty())
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
            case .analyticsTests:
                expect(name) == "AnalyticsTests"
            case .contextTests:
                expect(name) == "ContextTests"
            case .flowTests:
                expect(name) == "FlowTests"
            case .pluginTests:
                expect(name) == "PluginTests"
            case .pluginListTests:
                expect(name) == "PluginListTests"
            case .viewControllerTests:
                expect(name) == "ViewControllerTests"
            case .viewStateFactoryTests:
                expect(name) == "ViewStateFactoryTests"
            case .workerTests:
                expect(name) == "WorkerTests"
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
            case .analyticsTests:
                expect(filename) == "AnalyticsTests"
            case .contextTests:
                expect(filename) == "ContextTests"
            case .flowTests:
                expect(filename) == "FlowTests"
            case .pluginTests:
                expect(filename) == "PluginTests"
            case .pluginListTests:
                expect(filename) == "PluginListTests"
            case let .viewControllerTests(variation):
                expect(filename) == "ViewControllerTests\(variation == .swiftUI ? "-SwiftUI" : "")"
            case .viewStateFactoryTests:
                expect(filename) == "ViewStateFactoryTests"
            case .workerTests:
                expect(filename) == "WorkerTests"
            }
        }
    }

    func testNodeStencils() {
        // swiftlint:disable:next closure_body_length
        StencilTemplate.Variation.allCases.forEach { variation in
            let node: StencilTemplate.Node = .init(for: variation)
            expect(node.stencils(includePlugin: true, includeTests: true)) == [
                .analytics,
                .builder(variation),
                .context,
                .flow,
                .plugin,
                .state,
                .viewController(variation),
                .viewState,
                .analyticsTests,
                .contextTests,
                .flowTests,
                .pluginTests,
                .viewControllerTests(variation),
                .viewStateFactoryTests
            ]
            expect(node.stencils(includePlugin: false, includeTests: true)) == [
                .analytics,
                .builder(variation),
                .context,
                .flow,
                .state,
                .viewController(variation),
                .viewState,
                .analyticsTests,
                .contextTests,
                .flowTests,
                .viewControllerTests(variation),
                .viewStateFactoryTests
            ]
            expect(node.stencils(includePlugin: true, includeTests: false)) == [
                .analytics,
                .builder(variation),
                .context,
                .flow,
                .plugin,
                .state,
                .viewController(variation),
                .viewState
            ]
            expect(node.stencils(includePlugin: false, includeTests: false)) == [
                .analytics,
                .builder(variation),
                .context,
                .flow,
                .state,
                .viewController(variation),
                .viewState
            ]
        }
    }

    func testNodeViewInjectedStencils() {
        let nodeViewInjected: StencilTemplate.NodeViewInjected = .init()
        expect(nodeViewInjected.stencils(includeTests: false)) == [
            .analytics,
            .builder(.default),
            .context,
            .flow,
            .state
        ]
        expect(nodeViewInjected.stencils(includeTests: true)) == [
            .analytics,
            .builder(.default),
            .context,
            .flow,
            .state,
            .analyticsTests,
            .contextTests,
            .flowTests
        ]
    }

    // swiftlint:disable:next cyclomatic_complexity
    func testImports() {
        let config: Config = givenConfig()
        for stencilTemplate in StencilTemplate.allCases {
            for uiFramework in config.uiFrameworks {
                let imports: Set<String> = stencilTemplate.imports(with: config, including: uiFramework)
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
                case .analytics:
                    expect(imports) == [
                        "<baseImport>"
                    ]
                case .builder:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>",
                        "<reactiveImport>",
                        "<dependencyInjectionImport>",
                        "<builderImport>"
                    ]
                case .context:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>",
                        "<reactiveImport>"
                    ]
                case .flow:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>",
                        "<flowImport>"
                    ]
                case .plugin:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>",
                        "<dependencyInjectionImport>"
                    ]
                case .pluginList:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>",
                        "<dependencyInjectionImport>"
                    ]
                case .state:
                    expect(imports) == [
                        "<baseImport>"
                    ]
                case .viewController:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>",
                        "<reactiveImport>",
                        "<viewControllerImport>",
                        uiFrameworkImport
                    ]
                case .viewState:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>"
                    ]
                case .worker:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>",
                        "<reactiveImport>"
                    ]
                case .analyticsTests:
                    expect(imports) == [
                        "<baseTestImport>"
                    ]
                case .contextTests:
                    expect(imports) == [
                        "<baseTestImport>"
                    ]
                case .flowTests:
                    expect(imports) == [
                        "<baseTestImport>"
                    ]
                case .pluginTests:
                    expect(imports) == [
                        "NodesTesting",
                        "<baseTestImport>"
                    ]
                case .pluginListTests:
                    expect(imports) == [
                        "NodesTesting",
                        "<baseTestImport>"
                    ]
                case .viewControllerTests:
                    expect(imports) == [
                        "<baseTestImport>",
                        "<reactiveImport>"
                    ]
                case .viewStateFactoryTests:
                    expect(imports) == [
                        "<baseTestImport>"
                    ]
                case .workerTests:
                    expect(imports) == [
                        "<baseTestImport>"
                    ]
                }
            }
        }
    }
}

extension StencilTemplate {

    // swiftlint:disable:next strict_fileprivate
    fileprivate static let allCases: [Self] = [
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
        .worker,
        .analyticsTests,
        .contextTests,
        .flowTests,
        .pluginTests,
        .pluginListTests,
        .viewControllerTests(.default),
        .viewControllerTests(.swiftUI),
        .viewStateFactoryTests,
        .workerTests
    ]
}
