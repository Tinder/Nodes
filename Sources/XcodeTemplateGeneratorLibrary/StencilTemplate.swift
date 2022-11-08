//
//  StencilTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/3/22.
//

import Foundation

/// Contains a list of all Stencil source files used to generate the Xcode template files.
public enum StencilTemplate: CaseIterable, CustomStringConvertible {

    public static let allCases: [StencilTemplate] = [
        .analytics,
        .builder(.AppKit),
        .builder(.None),
        .builder(.SwiftUI),
        .builder(.UIKit),
        .context,
        .flow,
        .viewController(.AppKit),
        .viewController(.None),
        .viewController(.SwiftUI),
        .viewController(.UIKit),
        .worker
    ]

    /// The cases.
    case analytics
    case builder(UIFramework)
    case context
    case flow
    case plugin
    case pluginList
    case viewController(UIFramework)
    case worker

    /// A textual representation of self for ``CustomStringConvertible`` conformance.
    public var description: String { filename }

    /// The name of the .stencil file in the XcodeTemplateGeneratorLibrary bundle.
    public var filename: String {
        switch self {
        case .analytics:
            return "Analytics"
        case let .builder(uiFramework):
            return "Builder".appending(uiFramework.isSwiftUI ? "-SwiftUI" : "")
        case .context:
            return "Context"
        case .flow:
            return "Flow"
        case .plugin:
            return "Plugin"
        case .pluginList:
            return "PluginList"
        case let .viewController(uiFramework):
            return "ViewController".appending(uiFramework.isSwiftUI ? "-SwiftUI" : "")
        case .worker:
            return "Worker"
        }
    }

    /// The desired name of the Stencil for its rendered Swift file.
    public var outputFilename: String {
        filename.replacingOccurrences(of: "-SwiftUI", with: "")
    }
}

public enum UIFramework {
    case AppKit, None, SwiftUI, UIKit

    public var isSwiftUI: Bool { self == .SwiftUI }
}
