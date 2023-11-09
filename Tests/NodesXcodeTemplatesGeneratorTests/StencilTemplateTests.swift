//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesXcodeTemplatesGenerator
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
            .worker,
            .analyticsTests,
            .contextTests,
            .flowTests,
            .viewControllerTests,
            .viewStateTests
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
            case .analyticsTests:
                expect(name) == "AnalyticsTests"
            case .contextTests:
                expect(name) == "ContextTests"
            case .flowTests:
                expect(name) == "FlowTests"
            case .viewControllerTests:
                expect(name) == "ViewControllerTests"
            case .viewStateTests:
                expect(name) == "ViewStateTests"
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
            case .viewControllerTests:
                expect(filename) == "ViewControllerTests"
            case .viewStateTests:
                expect(filename) == "ViewStateTests"
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
                .viewState,
                .analyticsTests,
                .contextTests,
                .flowTests,
                .viewControllerTests,
                .viewStateTests
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
                    expect(imports) == ["Nodes", "<baseImport>"]
                case .builder:
                    expect(imports) == ["Nodes", "<baseImport>", "<reactiveImport>", "<dependencyInjectionImport>"]
                case .context, .worker:
                    expect(imports) == ["Nodes", "<baseImport>", "<reactiveImport>"]
                case .viewController:
                    expect(imports) == ["Nodes", "<baseImport>", "<reactiveImport>", uiFrameworkImport]
                case .plugin, .pluginList:
                    expect(imports) == ["Nodes", "<baseImport>", "<dependencyInjectionImport>"]
                case .contextTests, .analyticsTests, .viewControllerTests, .viewStateTests, .flowTests:
                    expect(imports) == ["<baseTestImports>"]
                }
            }
        }
    }
}
