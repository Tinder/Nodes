//
//  PluginNodeTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

internal struct PluginNodeTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String = "Plugin (for Node)"
    internal let stencils: [String] = ["Plugin"]
    internal let context: Context

    internal let propertyList: PropertyList =
        .init(description: "The source file implementing a Plugin for a Node.",
              sortOrder: 5) {
            Option(identifier: "productName",
                   name: "Node name:",
                   description: "The name of the Plugin")
        }

    internal init(config: Config) {
        context = PluginContext(
            fileHeader: config.fileHeader,
            pluginName: config.variable("productName"),
            pluginImports: config.imports(for: .plugin)
        )
    }
}
