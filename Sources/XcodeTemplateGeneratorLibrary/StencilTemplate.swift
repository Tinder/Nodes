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
    case state
    case viewController(Variation)
    case viewState
    case worker

    /// Alternate Stencil source files for specific use cases.
    public enum Variation: String, Equatable, CaseIterable {

        case `default` = ""
        case swiftUI = "-SwiftUI"

        internal static func variation(for kind: UIFramework.Kind) -> Self {
            kind == .swiftUI ? .swiftUI : .default
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
        .state,
        .viewController(.default),
        .viewController(.swiftUI),
        .viewState,
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
        case .state:
            return "State"
        case .viewController:
            return "ViewController"
        case .viewState:
            return "ViewState"
        case .worker:
            return "Worker"
        }
    }

    /// The name of the Stencil source file in the XcodeTemplateGeneratorLibrary bundle.
    public var filename: String {
        switch self {
        case .analytics, .context, .flow, .plugin, .pluginList, .state, .viewState, .worker:
            return description
        case let .builder(variation), let .viewController(variation):
            return description.appending(variation.rawValue)
        }
    }

    /// The StencilTemplate cases that represent a Node.
    ///
    /// - Parameters:
    ///   - variation: The Stencil variation.
    ///   - withViewController: A Boolean indicating whether or not to include the `viewController` stencil.
    ///
    /// - Returns: An array of StencilTemplate cases.
    public static func nodeStencils(
        for variation: Variation = .default,
        withViewController isViewControllerIncluded: Bool = true
    ) -> [StencilTemplate] {
        if isViewControllerIncluded {
            return [
                .analytics,
                .builder(variation),
                .context,
                .flow,
                .state,
                .viewController(variation),
                .viewState
            ]
        } else {
            return [
                .analytics,
                .builder(variation),
                .context,
                .flow,
                .state
            ]
        }
    }
}
