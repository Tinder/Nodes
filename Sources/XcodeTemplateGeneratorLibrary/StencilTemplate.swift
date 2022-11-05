//
//  StencilTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/3/22.
//

import Foundation

/// Contains a list of all Stencil source files used to generate Xcode template files.
public enum StencilTemplate: String, CaseIterable {
    case analytics = "Analytics"
    case builder = "Builder"
    case builderSwiftUI = "Builder-SwiftUI"
    case context = "Context"
    case flow = "Flow"
    case plugin = "Plugin"
    case pluginList = "PluginList"
    case viewController = "ViewController"
    case viewControllerSwiftUI = "ViewController-SwiftUI"
    case worker = "Worker"
}
