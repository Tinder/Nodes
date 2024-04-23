//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

// swiftlint:disable:next type_body_length
public enum StencilTemplate: Sendable, Equatable, CustomStringConvertible {

    case analytics
    case analyticsTests
    case builder(Variation)
    case builderTests
    case context
    case contextTests
    case flow
    case flowTests
    case plugin
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

    public enum Variation: String, Sendable, Equatable, CaseIterable {

        case `default` = ""
        case swiftUI = "-SwiftUI"

        public static func variation(for kind: UIFramework.Kind) -> Self {
            kind == .swiftUI ? .swiftUI : .default
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
        public let plugin: StencilTemplate
        public let pluginTests: StencilTemplate
        public let state: StencilTemplate
        public let viewController: StencilTemplate
        public let viewControllerTests: StencilTemplate
        public let viewState: StencilTemplate
        public let viewStateFactoryTests: StencilTemplate

        public init(for variation: StencilTemplate.Variation) {
            self.analytics = .analytics
            self.analyticsTests = .analyticsTests
            self.builder = .builder(variation)
            self.builderTests = .builderTests
            self.context = .context
            self.contextTests = .contextTests
            self.flow = .flow
            self.flowTests = .flowTests
            self.plugin = .plugin
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
                state,
                viewController,
                viewState
            ] + (includePlugin ? [.plugin] : [])
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
        public let plugin: StencilTemplate
        public let state: StencilTemplate

        public init() {
            self.analytics = .analytics
            self.analyticsTests = .analyticsTests
            self.builder = .builder(.default)
            self.builderTests = .builderTests
            self.context = .context
            self.contextTests = .contextTests
            self.flow = .flow
            self.flowTests = .flowTests
            self.plugin = .plugin
            self.state = .state
        }

        public func stencils(includeTests: Bool) -> [StencilTemplate] {
            let stencils: [StencilTemplate] = [
                analytics,
                builder,
                context,
                flow,
                state
            ]
            guard includeTests
            else { return stencils }
            let testsStencils: [StencilTemplate] = [
                analyticsTests,
                builderTests,
                contextTests,
                flowTests
            ]
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
        case .plugin:
            "Plugin"
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
            description.appending(variation.rawValue)
        case .builderTests:
            description
        case .context, .contextTests:
            description
        case .flow, .flowTests:
            description
        case .plugin, .pluginTests:
            description
        case .pluginList, .pluginListTests:
            description
        case .state:
            description
        case let .viewController(variation), let .viewControllerTests(variation):
            description.appending(variation.rawValue)
        case .viewState, .viewStateFactoryTests:
            description
        case .worker, .workerTests:
            description
        }
    }

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    public func imports(with config: Config, including uiFramework: UIFramework? = nil) -> Set<String> {
        let viewControllerImports: Set<String> = config
            .baseImports
            .union(["Nodes"])
            .union(config.reactiveImports)
            .union(config.viewControllerImports)
        return switch self {
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
        case .flow:
            config.baseImports
                .union(["Nodes"])
                .union(config.flowImports)
        case .flowTests:
            config.baseTestImports
        case .plugin:
            config.baseImports
                .union(["Nodes"])
                .union(config.dependencyInjectionImports)
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
            uiFramework.flatMap { viewControllerImports.union([$0.import]) } ?? viewControllerImports
        case .viewControllerTests:
            config.baseTestImports
                .union(config.reactiveImports)
        case .viewState:
            config.baseImports
                .union(["Nodes"])
        case .viewStateFactoryTests:
            config.baseTestImports
        case .worker:
            config.baseImports
                .union(["Nodes"])
                .union(config.reactiveImports)
        case .workerTests:
            config.baseTestImports
        }
    }
}
