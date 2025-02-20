//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

// swiftlint:disable:next type_body_length
public enum StencilTemplate: CustomStringConvertible, Equatable, Sendable {

    case analytics
    case analyticsTests
    case builder(Variation)
    case builderTests
    case context
    case contextTests
    case flow
    case flowTests
    case interface(Variation)
    case plugin
    case pluginInterface
    case pluginTests
    case pluginList
    case pluginListTests
    case state
    case viewController(Variation)
    case viewControllerTests(Variation)
    case viewState
    case viewStateFactoryTests
    case worker
    case workerTests

    public enum Variation: CaseIterable, Equatable, Sendable {

        case regular
        case swiftUI

        public var suffix: String {
            switch self {
            case .regular:
                ""
            case .swiftUI:
                "-SwiftUI"
            }
        }

        public static func variation(for kind: UIFramework.Kind) -> Self {
            kind.isHostingSwiftUI ? .swiftUI : .regular
        }
    }

    public struct Node {

        public let analytics: StencilTemplate
        public let analyticsTests: StencilTemplate
        public let builder: StencilTemplate
        public let builderTests: StencilTemplate
        public let context: StencilTemplate
        public let contextTests: StencilTemplate
        public let flow: StencilTemplate
        public let flowTests: StencilTemplate
        public let interface: StencilTemplate
        public let plugin: StencilTemplate
        public let pluginInterface: StencilTemplate
        public let pluginTests: StencilTemplate
        public let state: StencilTemplate
        public let viewController: StencilTemplate
        public let viewControllerTests: StencilTemplate
        public let viewState: StencilTemplate
        public let viewStateFactoryTests: StencilTemplate

        public init(_ variation: StencilTemplate.Variation) {
            self.analytics = .analytics
            self.analyticsTests = .analyticsTests
            self.builder = .builder(variation)
            self.builderTests = .builderTests
            self.context = .context
            self.contextTests = .contextTests
            self.flow = .flow
            self.flowTests = .flowTests
            self.interface = .interface(variation)
            self.plugin = .plugin
            self.pluginInterface = .pluginInterface
            self.pluginTests = .pluginTests
            self.state = .state
            self.viewController = .viewController(variation)
            self.viewControllerTests = .viewControllerTests(variation)
            self.viewState = .viewState
            self.viewStateFactoryTests = .viewStateFactoryTests
        }

        public func stencils(includePlugin: Bool, includeTests: Bool) -> [StencilTemplate] {
            let stencils: [StencilTemplate] = [
                analytics,
                builder,
                context,
                flow,
                interface,
                state,
                viewController,
                viewState
            ] + (includePlugin ? [.plugin, .pluginInterface] : [])
            guard includeTests
            else { return stencils }
            let testsStencils: [StencilTemplate] = [
                analyticsTests,
                builderTests,
                contextTests,
                flowTests,
                viewControllerTests,
                viewStateFactoryTests
            ] + (includePlugin ? [.pluginTests] : [])
            return stencils + testsStencils
        }
    }

    public struct NodeViewInjected {

        public let analytics: StencilTemplate
        public let analyticsTests: StencilTemplate
        public let builder: StencilTemplate
        public let builderTests: StencilTemplate
        public let context: StencilTemplate
        public let contextTests: StencilTemplate
        public let flow: StencilTemplate
        public let flowTests: StencilTemplate
        public let interface: StencilTemplate
        public let plugin: StencilTemplate
        public let pluginInterface: StencilTemplate
        public let pluginTests: StencilTemplate
        public let state: StencilTemplate

        public init() {
            self.analytics = .analytics
            self.analyticsTests = .analyticsTests
            self.builder = .builder(.regular)
            self.builderTests = .builderTests
            self.context = .context
            self.contextTests = .contextTests
            self.flow = .flow
            self.flowTests = .flowTests
            self.interface = .interface(.regular)
            self.plugin = .plugin
            self.pluginInterface = .pluginInterface
            self.pluginTests = .pluginTests
            self.state = .state
        }

        public func stencils(includePlugin: Bool, includeTests: Bool) -> [StencilTemplate] {
            let stencils: [StencilTemplate] = [
                analytics,
                builder,
                context,
                flow,
                interface,
                state
            ] + (includePlugin ? [.plugin, .pluginInterface] : [])
            guard includeTests
            else { return stencils }
            let testsStencils: [StencilTemplate] = [
                analyticsTests,
                builderTests,
                contextTests,
                flowTests
            ] + (includePlugin ? [.pluginTests] : [])
            return stencils + testsStencils
        }
    }

    public var description: String { name }

    public var name: String {
        switch self {
        case .analytics:
            "Analytics"
        case .analyticsTests:
            "AnalyticsTests"
        case .builder:
            "Builder"
        case .builderTests:
            "BuilderTests"
        case .context:
            "Context"
        case .contextTests:
            "ContextTests"
        case .flow:
            "Flow"
        case .flowTests:
            "FlowTests"
        case .interface:
            "Interface"
        case .plugin:
            "Plugin"
        case .pluginInterface:
            "PluginInterface"
        case .pluginTests:
            "PluginTests"
        case .pluginList:
            "PluginList"
        case .pluginListTests:
            "PluginListTests"
        case .state:
            "State"
        case .viewController:
            "ViewController"
        case .viewControllerTests:
            "ViewControllerTests"
        case .viewState:
            "ViewState"
        case .viewStateFactoryTests:
            "ViewStateFactoryTests"
        case .worker:
            "Worker"
        case .workerTests:
            "WorkerTests"
        }
    }

    public var filename: String {
        switch self {
        case .analytics, .analyticsTests:
            description
        case let .builder(variation):
            description.appending(variation.suffix)
        case .builderTests:
            description
        case .context, .contextTests:
            description
        case .flow, .flowTests:
            description
        case .plugin, .pluginTests:
            description
        case .pluginInterface:
            description
        case let .interface(variation):
            description.appending(variation.suffix)
        case .pluginList, .pluginListTests:
            description
        case .state:
            description
        case let .viewController(variation), let .viewControllerTests(variation):
            description.appending(variation.suffix)
        case .viewState, .viewStateFactoryTests:
            description
        case .worker, .workerTests:
            description
        }
    }

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    public func imports(with config: Config, including uiFramework: UIFramework? = nil) -> Set<String> {
        switch self {
        case .analytics:
            config.baseImports
        case .analyticsTests:
            config.baseTestImports
        case .builder:
            config.baseImports
                .union(["Nodes"])
                .union(config.reactiveImports)
                .union(config.dependencyInjectionImports)
                .union(config.builderImports)
        case .builderTests:
            config.baseTestImports
                .union(["NodesTesting"])
        case .context:
            config.baseImports
                .union(["Nodes"])
                .union(config.reactiveImports)
        case .contextTests:
            config.baseTestImports
                .union(["Nodes"])
                .union(uiFramework == nil ? [] : ["NodesTesting"])
        case .flow:
            config.baseImports
                .union(["Nodes"])
                .union(config.flowImports)
        case .flowTests:
            config.baseTestImports
        case .interface:
            config.baseImports
                .union(["Nodes"])
        case .plugin:
            config.baseImports
                .union(["Nodes"])
                .union(config.dependencyInjectionImports)
        case .pluginInterface:
            config.baseImports
        case .pluginTests:
            config.baseTestImports
                .union(["NodesTesting"])
        case .pluginList:
            config.baseImports
                .union(["Nodes"])
                .union(config.dependencyInjectionImports)
                .union(config.pluginListImports)
        case .pluginListTests:
            config.baseTestImports
                .union(["NodesTesting"])
        case .state:
            config.baseImports
        case .viewController:
            uiFramework == nil ? [] : config.baseImports
                .union(["Nodes"])
                .union(config.reactiveImports)
                .union(config.viewControllerImports)
                .union(uiFramework.flatMap { [$0.import] } ?? [])
        case .viewControllerTests:
            uiFramework == nil ? [] : config.baseTestImports
                .union(uiFramework?.kind.isHostingSwiftUI == true ? ["NodesTesting"] : config.reactiveImports)
        case .viewState:
            uiFramework == nil ? [] : config.baseImports
                .union(["Nodes"])
        case .viewStateFactoryTests:
            uiFramework == nil ? [] : config.baseTestImports
        case .worker:
            config.baseImports
                .union(["Nodes"])
                .union(config.reactiveImports)
        case .workerTests:
            config.baseTestImports
        }
    }
}
