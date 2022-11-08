//
//  StencilTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/3/22.
//

import Foundation

/// Contains a list of all Stencil source files used to generate the Xcode template files.
public enum StencilTemplate: CaseIterable, CustomStringConvertible {

    public enum NodeKind {
        case ownsView(swiftUI: Bool)
        case viewInjected
    }

    public static let allCases: [StencilTemplate] = [
        .analytics,
        .builder(swiftUI: false),
        .builder(swiftUI: true),
        .context,
        .flow,
        .viewController(swiftUI: false),
        .viewController(swiftUI: true),
        .worker
    ]

    public static func node(_ kind: NodeKind) -> [StencilTemplate] {
        switch kind {
        case let .ownsView(swiftUI):
            return [
                .analytics,
                .builder(swiftUI: swiftUI),
                .context,
                .flow,
                .viewController(swiftUI: swiftUI),
                .worker
            ]
        case .viewInjected:
            return [
                .analytics,
                .builder(swiftUI: false),
                .context,
                .flow,
                .worker
            ]
        }
    }

    /// The cases.
    case analytics
    case builder(swiftUI: Bool)
    case context
    case flow
    case plugin
    case pluginList
    case viewController(swiftUI: Bool)
    case worker

    /// A textual representation of self for ``CustomStringConvertible`` conformance.
    public var description: String { filename }

    /// The name of the .stencil file in the XcodeTemplateGeneratorLibrary bundle.
    public var filename: String {
        switch self {
        case .analytics:
            return "Analytics"
        case let .builder(swiftUI):
            return "Builder".appending(swiftUI ? "-SwiftUI" : "")
        case .context:
            return "Context"
        case .flow:
            return "Flow"
        case .plugin:
            return "Plugin"
        case .pluginList:
            return "PluginList"
        case let .viewController(swiftUI):
            return "ViewController".appending(swiftUI ? "-SwiftUI" : "")
        case .worker:
            return "Worker"
        }
    }

    /// The desired name of the Stencil for its rendered Swift file.
    public var outputFilename: String {
        filename.replacingOccurrences(of: "-SwiftUI", with: "")
    }
}
