//
//  StencilTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/7/22.
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
    case viewController(Variation)
    case worker

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
        internal let viewController: StencilTemplate
        internal let worker: StencilTemplate

        internal var stencils: [StencilTemplate] {
            [analytics, builder, context, flow, viewController, worker]
        }

        internal init(for variation: StencilTemplate.Variation) {
            self.analytics = .analytics
            self.builder = .builder(variation)
            self.context = .context
            self.flow = .flow
            self.viewController = .viewController(variation)
            self.worker = .worker
        }
    }

    /// The StencilTemplate cases that represent a view injected Node.
    internal struct NodeViewInjected {
        internal let analytics: StencilTemplate
        internal let builder: StencilTemplate
        internal let context: StencilTemplate
        internal let flow: StencilTemplate
        internal let worker: StencilTemplate

        internal var stencils: [StencilTemplate] {
            [analytics, builder, context, flow, worker]
        }

        internal init() {
            self.analytics = .analytics
            self.builder = .builder(.default)
            self.context = .context
            self.flow = .flow
            self.worker = .worker
        }
    }

    /// An array of StencilTemplate cases for ``CaseIterable`` conformance.
    public static let allCases: [StencilTemplate] = [
        .analytics,
        .builder(.default),
        .builder(.swiftUI),
        .context,
        .flow,
        .plugin,
        .pluginList,
        .viewController(.default),
        .viewController(.swiftUI),
        .worker
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
        case .viewController:
            return "ViewController"
        case .worker:
            return "Worker"
        }
    }

    /// The name of the Stencil source file in the XcodeTemplateGeneratorLibrary bundle.
    public var filename: String {
        switch self {
        case .analytics, .context, .flow, .plugin, .pluginList, .worker:
            return description
        case let .builder(variation), let .viewController(variation):
            return description.appending(variation.rawValue)
        }
    }
}
