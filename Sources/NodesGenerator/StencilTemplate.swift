//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

public enum StencilTemplate: Equatable, CustomStringConvertible {

    case analytics
    case builder(Variation)
    case context
    case flow
    case plugin
    case pluginList
    case state
    case viewController(Variation)
    case viewState
    case worker

    case analyticsTests
    case contextTests
    case flowTests
    case pluginTests
    case viewControllerTests(Variation)
    case viewStateFactoryTests
    case workerTests

    public enum Variation: String, Equatable, CaseIterable {

        case `default` = ""
        case swiftUI = "-SwiftUI"

        public static func variation(for kind: UIFramework.Kind) -> Self {
            kind == .swiftUI ? .swiftUI : .default
        }
    }

    public struct Node {

        public let analytics: StencilTemplate
        public let builder: StencilTemplate
        public let context: StencilTemplate
        public let flow: StencilTemplate
        public let plugin: StencilTemplate
        public let state: StencilTemplate
        public let viewController: StencilTemplate
        public let viewState: StencilTemplate

        public let analyticsTests: StencilTemplate
        public let contextTests: StencilTemplate
        public let flowTests: StencilTemplate
        public let pluginTests: StencilTemplate
        public let viewControllerTests: StencilTemplate
        public let viewStateFactoryTests: StencilTemplate

        public init(for variation: StencilTemplate.Variation) {
            self.analytics = .analytics
            self.builder = .builder(variation)
            self.context = .context
            self.flow = .flow
            self.plugin = .plugin
            self.state = .state
            self.viewController = .viewController(variation)
            self.viewState = .viewState
            self.analyticsTests = .analyticsTests
            self.contextTests = .contextTests
            self.flowTests = .flowTests
            self.pluginTests = .pluginTests
            self.viewControllerTests = .viewControllerTests(variation)
            self.viewStateFactoryTests = .viewStateFactoryTests
        }

        public func stencils(
            includePlugin: Bool = false,
            includeTests: Bool = false
        ) -> [StencilTemplate] {
            var stencils: [StencilTemplate] = [
                analytics,
                builder,
                context,
                flow
            ]
            if includePlugin {
                stencils.append(.plugin)
            }
            stencils += [
                state,
                viewController,
                viewState
            ]
            guard includeTests
            else { return stencils }
            stencils += [
                analyticsTests,
                contextTests,
                flowTests
            ]
            if includePlugin {
                stencils.append(.pluginTests)
            }
            return stencils + [
                viewControllerTests,
                viewStateFactoryTests
            ]
        }
    }

    public struct NodeViewInjected {

        public let analytics: StencilTemplate
        public let builder: StencilTemplate
        public let context: StencilTemplate
        public let flow: StencilTemplate
        public let state: StencilTemplate

        public let analyticsTests: StencilTemplate
        public let contextTests: StencilTemplate
        public let flowTests: StencilTemplate

        public init() {
            self.analytics = .analytics
            self.builder = .builder(.default)
            self.context = .context
            self.flow = .flow
            self.state = .state
            self.analyticsTests = .analyticsTests
            self.contextTests = .contextTests
            self.flowTests = .flowTests
        }

        public func stencils(
            includeTests: Bool = false
        ) -> [StencilTemplate] {
            let stencils: [StencilTemplate] = [
                analytics,
                builder,
                context,
                flow,
                state
            ]
            guard includeTests
            else { return stencils }
            return stencils + [
                analyticsTests,
                contextTests,
                flowTests
            ]
        }
    }

    public var description: String { name }

    public var name: String {
        switch self {
        case .analytics:
            "Analytics"
        case .builder:
            "Builder"
        case .context:
            "Context"
        case .flow:
            "Flow"
        case .plugin:
            "Plugin"
        case .pluginList:
            "PluginList"
        case .state:
            "State"
        case .viewController:
            "ViewController"
        case .viewState:
            "ViewState"
        case .worker:
            "Worker"
        case .analyticsTests:
            "AnalyticsTests"
        case .contextTests:
            "ContextTests"
        case .flowTests:
            "FlowTests"
        case .pluginTests:
            "PluginTests"
        case .viewControllerTests:
            "ViewControllerTests"
        case .viewStateFactoryTests:
            "ViewStateFactoryTests"
        case .workerTests:
            "WorkerTests"
        }
    }

    public var filename: String {
        switch self {
        case let .builder(variation), let .viewController(variation), let .viewControllerTests(variation):
            description.appending(variation.rawValue)
        case .analytics, .context, .flow, .plugin, .pluginList, .state, .viewState, .worker:
            description
        case .analyticsTests, .contextTests, .flowTests, .pluginTests, .viewStateFactoryTests, .workerTests:
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
        case .builder:
            config.baseImports
                .union(["Nodes"])
                .union(config.reactiveImports)
                .union(config.dependencyInjectionImports)
                .union(config.builderImports)
        case .context:
            config.baseImports
                .union(["Nodes"])
                .union(config.reactiveImports)
        case .flow:
            config.baseImports
                .union(["Nodes"])
                .union(config.flowImports)
        case .plugin:
            config.baseImports
                .union(["Nodes"])
                .union(config.dependencyInjectionImports)
        case .pluginList:
            config.baseImports
                .union(["Nodes"])
                .union(config.dependencyInjectionImports)
        case .state:
            config.baseImports
        case .viewController:
            uiFramework.flatMap { viewControllerImports.union([$0.import]) } ?? viewControllerImports
        case .viewState:
            config.baseImports
                .union(["Nodes"])
        case .worker:
            config.baseImports
                .union(["Nodes"])
                .union(config.reactiveImports)
        case .analyticsTests:
            config.baseTestImports
        case .contextTests:
            config.baseTestImports
        case .flowTests:
            config.baseTestImports
        case .pluginTests:
            config.baseTestImports
                .union(["NodesTesting"])
        case .viewControllerTests:
            config.baseTestImports
                .union(config.reactiveImports)
        case .viewStateFactoryTests:
            config.baseTestImports
        case .workerTests:
            config.baseTestImports
        }
    }
}
