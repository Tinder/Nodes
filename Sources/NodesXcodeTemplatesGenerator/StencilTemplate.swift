//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Foundation

/// Every Stencil source file is represented by a case. Some cases have a variation.
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

    // Test stencils
    case analyticsTests
    case contextTests
    case flowTests
    case viewControllerTests
    case viewStateTests

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

        // Test stencils
        internal let analyticsTests: StencilTemplate
        internal let contextTests: StencilTemplate
        internal let flowTests: StencilTemplate
        internal let viewControllerTests: StencilTemplate
        internal let viewStateTests: StencilTemplate

        internal init(for variation: StencilTemplate.Variation) {
            self.analytics = .analytics
            self.builder = .builder(variation)
            self.context = .context
            self.flow = .flow
            self.state = .state
            self.viewController = .viewController(variation)
            self.viewState = .viewState
            self.analyticsTests = .analyticsTests
            self.contextTests = .contextTests
            self.flowTests = .flowTests
            self.viewControllerTests = .viewControllerTests
            self.viewStateTests = .viewStateTests
        }

        internal func stencils(includeTests: Bool = false) -> [StencilTemplate] {
            let stencils: [StencilTemplate] = [
                analytics,
                builder,
                context,
                flow,
                state,
                viewController,
                viewState
            ]
            guard includeTests
            else { return stencils }
            return stencils + [
                analyticsTests,
                contextTests,
                flowTests,
                viewControllerTests,
                viewStateTests
            ]
        }
    }

    /// The StencilTemplate cases that represent a view injected Node.
    internal struct NodeViewInjected {
        internal let analytics: StencilTemplate
        internal let builder: StencilTemplate
        internal let context: StencilTemplate
        internal let flow: StencilTemplate
        internal let state: StencilTemplate

        internal init() {
            self.analytics = .analytics
            self.builder = .builder(.default)
            self.context = .context
            self.flow = .flow
            self.state = .state
        }

        internal func stencils(includeTests: Bool = false) -> [StencilTemplate] {
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
        case .viewControllerTests:
            return "ViewControllerTests"
        case .viewStateTests:
            return "ViewStateTests"
        }
    }

    /// The name of the Stencil source file in the bundle.
    public var filename: String {
        switch self {
        case .analytics, .context, .flow, .plugin, .pluginList, .state, .viewState, .worker:
            return description
        case let .builder(variation), let .viewController(variation):
            return description.appending(variation.rawValue)
        case .analyticsTests, .contextTests, .flowTests, .viewControllerTests, .viewStateTests:
            return description
        }
    }

    internal func imports(for uiFramework: UIFramework, config: XcodeTemplates.Config) -> Set<String> {
        switch self {
        case .analytics, .builder, .context, .flow, .plugin, .pluginList, .state, .viewState, .worker:
            return imports(config: config)
        case .viewController:
            return imports(config: config).union([uiFramework.import])
        case .analyticsTests, .contextTests, .flowTests, .viewControllerTests, .viewStateTests:
            return imports(config: config)
        }
    }

    internal func imports(config: XcodeTemplates.Config) -> Set<String> {
        let baseImports: Set<String> = config.baseImports.union(["Nodes"])
        switch self {
        case .analytics, .flow, .state, .viewState:
            return baseImports
        case .builder:
            return baseImports.union(config.reactiveImports).union(config.dependencyInjectionImports)
        case .context, .viewController, .worker:
            return baseImports.union(config.reactiveImports)
        case .plugin, .pluginList:
            return baseImports.union(config.dependencyInjectionImports)
        case .analyticsTests, .contextTests, .flowTests, .viewControllerTests, .viewStateTests:
            return config.baseTestImports
        }
    }
}
