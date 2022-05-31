//
//  PluginMapNodeTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

internal struct PluginMapNodeTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String = "Plugin Map (for Node)"
    internal let type: String = "Plugin"
    internal let stencils: [String] = ["PluginMap"]
    internal let context: Context

    internal let propertyList: PropertyList =
        .init(description: "The source file implementing a Plugin Map.",
              sortOrder: 5) {
            Option(identifier: "productName",
                   name: "Plugin Map name:",
                   description: "The name of the Plugin Map")
        }

    internal init(config: Config) {
        context = PluginMapContext(
            fileHeader: config.fileHeader,
            pluginMapName: config.variable("productName"),
            pluginMapImports: config.imports(for: .diGraph),
            viewControllableFlowType: config.viewControllableFlowType
        )
    }
}
