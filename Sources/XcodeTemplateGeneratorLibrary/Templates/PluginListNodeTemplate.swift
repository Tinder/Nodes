//
//  PluginListNodeTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

internal struct PluginListNodeTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String = "Plugin List (for Node)"
    internal let stencils: [StencilTemplate]
    internal let context: Context

    internal let propertyList: PropertyList =
        .init(description: "The source file implementing a Plugin List.",
              sortOrder: 4) {
            Option(identifier: "productName",
                   name: "Plugin List name:",
                   description: "The name of the Plugin List")
        }

    internal init(config: Config) {
        let pluginListContext = PluginListContext(
            fileHeader: config.fileHeader,
            pluginListName: config.variable("productName"),
            pluginListImports: config.imports(for: .diGraph),
            viewControllableFlowType: config.viewControllableFlowType
        )
        stencils = [pluginListContext.stencil]
        context = pluginListContext
    }
}
