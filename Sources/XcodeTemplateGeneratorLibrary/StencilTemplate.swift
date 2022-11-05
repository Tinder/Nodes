//
//  StencilTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/3/22.
//

import Foundation

/// Contains a list of all Stencil source files used to generate the Xcode template files.
public enum StencilTemplate: CaseIterable {
    case analytics
    case builder
    case builderSwiftUI
    case context
    case flow
    case plugin
    case pluginList
    case viewController
    case viewControllerSwiftUI
    case worker

    /// The name of the .stencil file in the XcodeTemplateGeneratorLibrary bundle.
    public var fileName: String {
        switch self {
        case .analytics:
            return "Analytics"
        case .builder:
            return "Builder"
        case .builderSwiftUI:
            return "Builder-SwiftUI"
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
        case .viewControllerSwiftUI:
            return "ViewController-SwiftUI"
        case .worker:
            return "Worker"
        }
    }

    /// The desired name of the Stencil for its rendered Swift file.
    public var outputFilename: String {
        switch self {
        case .analytics:
            return fileName
        case .builder, .builderSwiftUI:
            return fileName.replacingOccurrences(of: "-SwiftUI", with: "")
        case .context:
            return fileName
        case .flow:
            return fileName
        case .plugin:
            return fileName
        case .pluginList:
            return fileName
        case .viewController, .viewControllerSwiftUI:
            return fileName.replacingOccurrences(of: "-SwiftUI", with: "")
        case .worker:
            return fileName
        }
    }
}
