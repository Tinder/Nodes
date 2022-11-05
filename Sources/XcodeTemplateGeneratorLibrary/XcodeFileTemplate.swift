//
//  XcodeFileTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/5/22.
//

import Foundation

public enum XcodeFileTemplate: String, Decodable, CaseIterable, CustomStringConvertible {

    public var description: String { rawValue }

    case node = "Node"
    case nodeSwiftUI = "NodeSwiftUI"
    case nodeViewInjected = "NodeViewInjected"
    case pluginListNode = "PluginListNode"
    case pluginNode = "PluginNode"
    case plugin = "Plugin"
    case worker = "Worker"
}
