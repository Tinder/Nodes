//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesGenerator
import SnapshotTesting
import XCTest

final class StencilTemplateTests: XCTestCase, TestFactories {

    func testVariationSuffix() {
        StencilTemplate.Variation.allCases.forEach { variation in
            switch variation {
            case .regular:
                expect(variation.suffix).to(beEmpty())
            case .swiftUI:
                expect(variation.suffix) == "-SwiftUI"
            }
        }
    }

    func testVariationForKind() {
        UIFramework.Kind.allCases.forEach { kind in
            let variation: StencilTemplate.Variation = .variation(for: kind)
            switch kind {
            case .appKit, .uiKit, .custom:
                expect(variation) == .regular
            case .appKitSwiftUI, .uiKitSwiftUI:
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
            case .analyticsTests:
                expect(name) == "AnalyticsTests"
            case .builder:
                expect(name) == "Builder"
            case .builderTests:
                expect(name) == "BuilderTests"
            case .context:
                expect(name) == "Context"
            case .contextTests:
                expect(name) == "ContextTests"
            case .flow:
                expect(name) == "Flow"
            case .flowTests:
                expect(name) == "FlowTests"
            case .plugin:
                expect(name) == "Plugin"
            case .pluginTests:
                expect(name) == "PluginTests"
            case .pluginList:
                expect(name) == "PluginList"
            case .pluginListTests:
                expect(name) == "PluginListTests"
            case .state:
                expect(name) == "State"
            case .viewController:
                expect(name) == "ViewController"
            case .viewControllerTests:
                expect(name) == "ViewControllerTests"
            case .viewState:
                expect(name) == "ViewState"
            case .viewStateFactoryTests:
                expect(name) == "ViewStateFactoryTests"
            case .worker:
                expect(name) == "Worker"
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
            case .analyticsTests:
                expect(filename) == "AnalyticsTests"
            case let .builder(variation):
                expect(filename) == "Builder\(variation == .swiftUI ? "-SwiftUI" : "")"
            case .builderTests:
                expect(filename) == "BuilderTests"
            case .context:
                expect(filename) == "Context"
            case .contextTests:
                expect(filename) == "ContextTests"
            case .flow:
                expect(filename) == "Flow"
            case .flowTests:
                expect(filename) == "FlowTests"
            case .plugin:
                expect(filename) == "Plugin"
            case .pluginTests:
                expect(filename) == "PluginTests"
            case .pluginList:
                expect(filename) == "PluginList"
            case .pluginListTests:
                expect(filename) == "PluginListTests"
            case .state:
                expect(filename) == "State"
            case let .viewController(variation):
                expect(filename) == "ViewController\(variation == .swiftUI ? "-SwiftUI" : "")"
            case let .viewControllerTests(variation):
                expect(filename) == "ViewControllerTests\(variation == .swiftUI ? "-SwiftUI" : "")"
            case .viewState:
                expect(filename) == "ViewState"
            case .viewStateFactoryTests:
                expect(filename) == "ViewStateFactoryTests"
            case .worker:
                expect(filename) == "Worker"
            case .workerTests:
                expect(filename) == "WorkerTests"
            }
        }
    }

    func testNode() {
        StencilTemplate.Variation.allCases.forEach { variation in
            assertSnapshot(of: StencilTemplate.Node(variation),
                           as: .dump,
                           named: "Variation-\(variation)")
        }
    }

    func testNodeViewInjected() {
        assertSnapshot(of: StencilTemplate.NodeViewInjected(),
                       as: .dump)
    }

    func testNodeStencils() {
        // swiftlint:disable:next closure_body_length
        StencilTemplate.Variation.allCases.forEach { variation in
            let node: StencilTemplate.Node = .init(variation)
            expect(node.stencils(includePlugin: true, includeTests: true)) == [
                .analytics,
                .builder(variation),
                .context,
                .flow,
                .state,
                .viewController(variation),
                .viewState,
                .plugin,
                .analyticsTests,
                .builderTests,
                .contextTests,
                .flowTests,
                .viewControllerTests(variation),
                .viewStateFactoryTests,
                .pluginTests
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
                .builderTests,
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
                .state,
                .viewController(variation),
                .viewState,
                .plugin
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
        let node: StencilTemplate.NodeViewInjected = .init()
        expect(node.stencils(includePlugin: true, includeTests: true)) == [
            .analytics,
            .builder(.regular),
            .context,
            .flow,
            .state,
            .plugin,
            .analyticsTests,
            .builderTests,
            .contextTests,
            .flowTests,
            .pluginTests
        ]
        expect(node.stencils(includePlugin: false, includeTests: true)) == [
            .analytics,
            .builder(.regular),
            .context,
            .flow,
            .state,
            .analyticsTests,
            .builderTests,
            .contextTests,
            .flowTests
        ]
        expect(node.stencils(includePlugin: true, includeTests: false)) == [
            .analytics,
            .builder(.regular),
            .context,
            .flow,
            .state,
            .plugin
        ]
        expect(node.stencils(includePlugin: false, includeTests: false)) == [
            .analytics,
            .builder(.regular),
            .context,
            .flow,
            .state
        ]
    }

    // swiftlint:disable:next cyclomatic_complexity
    func testImportsWithConfigIncludingUIFramework() {
        let config: Config = givenConfig()
        for stencilTemplate in StencilTemplate.allCases {
            for uiFramework in config.uiFrameworks {
                let imports: Set<String> = stencilTemplate.imports(with: config, including: uiFramework)
                let uiFrameworkImport: String
                switch uiFramework.kind {
                case .appKit:
                    uiFrameworkImport = "AppKit"
                case .appKitSwiftUI:
                    uiFrameworkImport = "SwiftUI"
                case .uiKit:
                    uiFrameworkImport = "UIKit"
                case .uiKitSwiftUI:
                    uiFrameworkImport = "SwiftUI"
                case .custom:
                    uiFrameworkImport = "<uiFrameworkImport>"
                }
                switch stencilTemplate {
                case .analytics:
                    expect(imports) == [
                        "<baseImport>"
                    ]
                case .analyticsTests:
                    expect(imports) == [
                        "<baseTestImport>"
                    ]
                case .builder:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>",
                        "<reactiveImport>",
                        "<dependencyInjectionImport>",
                        "<builderImport>"
                    ]
                case .builderTests:
                    expect(imports) == [
                        "NodesTesting",
                        "<baseTestImport>"
                    ]
                case .context:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>",
                        "<reactiveImport>"
                    ]
                case .contextTests:
                    expect(imports) == [
                        "Nodes",
                        "<baseTestImport>",
                        "NodesTesting"
                    ]
                case .flow:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>",
                        "<flowImport>"
                    ]
                case .flowTests:
                    expect(imports) == [
                        "<baseTestImport>"
                    ]
                case .plugin:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>",
                        "<dependencyInjectionImport>"
                    ]
                case .pluginTests:
                    expect(imports) == [
                        "NodesTesting",
                        "<baseTestImport>"
                    ]
                case .pluginList:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>",
                        "<dependencyInjectionImport>",
                        "<pluginListImport>"
                    ]
                case .pluginListTests:
                    expect(imports) == [
                        "NodesTesting",
                        "<baseTestImport>"
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
                case .viewControllerTests:
                    expect(imports) == [
                        "<baseTestImport>",
                        uiFramework.kind.isHostingSwiftUI ? "NodesTesting" : "<reactiveImport>"
                    ]
                case .viewState:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>"
                    ]
                case .viewStateFactoryTests:
                    expect(imports) == [
                        "<baseTestImport>"
                    ]
                case .worker:
                    expect(imports) == [
                        "Nodes",
                        "<baseImport>",
                        "<reactiveImport>"
                    ]
                case .workerTests:
                    expect(imports) == [
                        "<baseTestImport>"
                    ]
                }
            }
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    func testImportsWithConfig() {
        let config: Config = givenConfig()
        for stencilTemplate in StencilTemplate.allCases {
            let imports: Set<String> = stencilTemplate.imports(with: config)
            switch stencilTemplate {
            case .analytics:
                expect(imports) == [
                    "<baseImport>"
                ]
            case .analyticsTests:
                expect(imports) == [
                    "<baseTestImport>"
                ]
            case .builder:
                expect(imports) == [
                    "Nodes",
                    "<baseImport>",
                    "<reactiveImport>",
                    "<dependencyInjectionImport>",
                    "<builderImport>"
                ]
            case .builderTests:
                expect(imports) == [
                    "NodesTesting",
                    "<baseTestImport>"
                ]
            case .context:
                expect(imports) == [
                    "Nodes",
                    "<baseImport>",
                    "<reactiveImport>"
                ]
            case .contextTests:
                expect(imports) == [
                    "Nodes",
                    "<baseTestImport>"
                ]
            case .flow:
                expect(imports) == [
                    "Nodes",
                    "<baseImport>",
                    "<flowImport>"
                ]
            case .flowTests:
                expect(imports) == [
                    "<baseTestImport>"
                ]
            case .plugin:
                expect(imports) == [
                    "Nodes",
                    "<baseImport>",
                    "<dependencyInjectionImport>"
                ]
            case .pluginTests:
                expect(imports) == [
                    "NodesTesting",
                    "<baseTestImport>"
                ]
            case .pluginList:
                expect(imports) == [
                    "Nodes",
                    "<baseImport>",
                    "<dependencyInjectionImport>",
                    "<pluginListImport>"
                ]
            case .pluginListTests:
                expect(imports) == [
                    "NodesTesting",
                    "<baseTestImport>"
                ]
            case .state:
                expect(imports) == [
                    "<baseImport>"
                ]
            case .viewController:
                expect(imports).to(beEmpty())
            case .viewControllerTests:
                expect(imports).to(beEmpty())
            case .viewState:
                expect(imports).to(beEmpty())
            case .viewStateFactoryTests:
                expect(imports).to(beEmpty())
            case .worker:
                expect(imports) == [
                    "Nodes",
                    "<baseImport>",
                    "<reactiveImport>"
                ]
            case .workerTests:
                expect(imports) == [
                    "<baseTestImport>"
                ]
            }
        }
    }
}

extension StencilTemplate {

    // swiftlint:disable:next strict_fileprivate
    fileprivate static let allCases: [Self] = [
        .analytics,
        .analyticsTests,
        .builder(.regular),
        .builder(.swiftUI),
        .builderTests,
        .context,
        .contextTests,
        .flow,
        .flowTests,
        .plugin,
        .pluginTests,
        .pluginList,
        .pluginListTests,
        .state,
        .viewController(.regular),
        .viewController(.swiftUI),
        .viewControllerTests(.regular),
        .viewControllerTests(.swiftUI),
        .viewState,
        .viewStateFactoryTests,
        .worker,
        .workerTests
    ]
}
