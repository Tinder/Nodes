//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Foundation

/// Every Stencil source file is represented by a case. Some cases have a variation.
public enum StencilTemplate: Equatable, CaseIterable, CustomStringConvertible {

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
    case contextTests
    case analyticsTests
    case viewControllerTests
    case viewStateTests
    case flowTests

    /// Alternate Stencil source files for specific use cases.
    public enum Variation: String, Equatable, CaseIterable {

        case `default` = ""
        case swiftUI = "-SwiftUI"

        internal static func variation(for kind: UIFramework.Kind) -> Self {
            kind == .swiftUI ? .swiftUI : .default
        }
    }

    /// The StencilTemplate cases that represent a Node.
    internal struct Node {
        internal let analytics: StencilTemplate
        internal let builder: StencilTemplate
        internal let context: StencilTemplate
        internal let flow: StencilTemplate
        internal let state: StencilTemplate
        internal let viewController: StencilTemplate
        internal let viewState: StencilTemplate
        internal let viewStateTests: StencilTemplate
        internal let viewControllerTests: StencilTemplate
        internal let analyticsTests: StencilTemplate
        internal let flowTests: StencilTemplate
        internal let contextTests: StencilTemplate

        internal var stencils: [StencilTemplate] {
            [
                analytics,
                builder,
                context,
                flow,
                state,
                viewController,
                viewState,
                viewStateTests,
                viewControllerTests,
                analyticsTests,
                flowTests,
                contextTests
            ]
        }

        internal init(for variation: StencilTemplate.Variation) {
            self.analytics = .analytics
            self.builder = .builder(variation)
            self.context = .context
            self.flow = .flow
            self.state = .state
            self.viewController = .viewController(variation)
            self.viewState = .viewState
            self.viewStateTests = .viewStateTests
            self.viewControllerTests = .viewControllerTests
            self.analyticsTests = .analyticsTests
            self.flowTests = .flowTests
            self.contextTests = .contextTests
        }
    }

    /// The StencilTemplate cases that represent a view injected Node.
    internal struct NodeViewInjected {
        internal let analytics: StencilTemplate
        internal let builder: StencilTemplate
        internal let context: StencilTemplate
        internal let flow: StencilTemplate
        internal let state: StencilTemplate

        internal var stencils: [StencilTemplate] {
            [analytics, builder, context, flow, state]
        }

        internal init() {
            self.analytics = .analytics
            self.builder = .builder(.default)
            self.context = .context
            self.flow = .flow
            self.state = .state
        }
    }

    /// An array of StencilTemplate cases for ``CaseIterable`` conformance.
    public static let allCases: [Self] = [
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
        .viewControllerTests,
        .flowTests,
        .viewStateTests
    ]

    /// A string representation of the case for ``CustomStringConvertible`` conformance.
    public var description: String { name }

    /// The name of the Stencil template.
    public var name: String {
        switch self {
        case .analytics:
            return "Analytics"
        case .builder:
            return "Builder"
        case .context:
            return "Context"
        case .flow:
            return "Flow"
        case .plugin:
            return "Plugin"
        case .pluginList:
            return "PluginList"
        case .state:
            return "State"
        case .viewController:
            return "ViewController"
        case .viewState:
            return "ViewState"
        case .worker:
            return "Worker"
        case .analyticsTests:
            return "AnalyticsTests"
        case .contextTests:
            return "ContextTests"
        case .flowTests:
            return "FlowTests"
        case .viewStateTests:
            return "ViewStateTests"
        case .viewControllerTests:
            return "viewControllerTests"
        }
    }

    /// The name of the Stencil source file in the bundle.
    public var filename: String {
        switch self {
        case .analytics,
                .context,
                .flow,
                .plugin,
                .pluginList,
                .state,
                .viewState,
                .worker,
                .viewStateTests,
                .flowTests,
                .contextTests,
                .analyticsTests,
                .viewControllerTests:
            return description
        case let .builder(variation), let .viewController(variation):
            return description.appending(variation.rawValue)
        }
    }

    internal func imports(for uiFramework: UIFramework, config: XcodeTemplates.Config) -> Set<String> {
        switch self {
        case .analytics,
                .builder,
                .context,
                .flow,
                .plugin,
                .pluginList,
                .state,
                .viewState,
                .worker,
                .viewStateTests,
                .flowTests,
                .contextTests,
                .analyticsTests,
                .viewControllerTests:
            return imports(config: config)
        case .viewController:
            return imports(config: config).union([uiFramework.import])
        }
    }

    internal func imports(config: XcodeTemplates.Config) -> Set<String> {
        let imports: Set<String> = config.baseImports.union(["Nodes"])
        switch self {
        case .analytics,
                .flow,
                .state,
                .viewState,
                .contextTests,
                .flowTests,
                .viewControllerTests,
                .analyticsTests,
                .viewStateTests:
            return imports
        case .builder:
            return imports.union(config.reactiveImports).union(config.dependencyInjectionImports)
        case .context, .viewController, .worker:
            return imports.union(config.reactiveImports)
        case .plugin, .pluginList:
            return imports.union(config.dependencyInjectionImports)
        }
    }
}
