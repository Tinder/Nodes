//
//  PluginTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

internal struct PluginTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String = "Plugin"
    internal let stencils: [String] = ["Plugin"]
    internal let context: Context

    internal let propertyList: PropertyList =
        .init(description: "The source file implementing a Plugin.",
              sortOrder: 6) {
            Option(identifier: "productName",
                   name: "Plugin name:",
                   description: "The name of the Plugin")
            Option(identifier: "returnType",
                   name: "Plugin return type:",
                   description: "The return type of the Plugin")
        }

    internal init(config: Config) {
        context = PluginContext(
            fileHeader: config.fileHeader,
            pluginName: config.variable("productName"),
            returnType: config.variable("returnType"),
            pluginImports: config.imports(for: .diGraph)
        )
    }
}
