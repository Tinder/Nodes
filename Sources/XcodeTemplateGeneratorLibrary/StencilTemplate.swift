//
//  StencilTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/7/22.
//

import Foundation

/// A list of all Stencil source files used to generate Xcode template files. Each case represents a single file.
public enum StencilTemplate: Equatable, CaseIterable, CustomStringConvertible {

    case analytics
    case builder(Variation)
    case context
    case flow
    case plugin
    case pluginList
    case viewController(Variation)
    case worker

    // Alternate Stencil source files for specific uses cases.
    public enum Variation: String, Equatable, CaseIterable {

        case `default` = ""
        case swiftUI = "-SwiftUI"

        internal static func variation(for kind: UIFramework.Kind) -> Self {
            kind == .swiftUI ? .swiftUI : .default
        }
    }

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

    /// A textual representation of self for ``CustomStringConvertible`` conformance.
    public var description: String {
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

    /// The name of the .stencil file in the XcodeTemplateGeneratorLibrary bundle.
    public var filename: String {
        switch self {
        case .analytics:
            return description
        case let .builder(variation):
            return description.appending(variation.rawValue)
        case .context:
            return description
        case .flow:
            return description
        case .plugin:
            return description
        case .pluginList:
            return description
        case let .viewController(variation):
            return description.appending(variation.rawValue)
        case .worker:
            return description
        }
    }

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
                .viewController(variation),
                .worker
            ]
        } else {
            return [
                .analytics,
                .builder(variation),
                .context,
                .flow,
                .worker
            ]
        }
    }
}
