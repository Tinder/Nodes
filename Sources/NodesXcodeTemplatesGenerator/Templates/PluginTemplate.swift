//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct PluginTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String = "Plugin"
    internal let stencils: [StencilTemplate]
    internal let context: Context

    internal let propertyList: PropertyList =
        .init(description: "The source file implementing a Plugin.",
              sortOrder: 8) {
            Option(identifier: "productName",
                   name: "Plugin name:",
                   description: "The name of the Plugin")
            Option(identifier: "returnType",
                   name: "Plugin return type:",
                   description: "The return type of the Plugin")
        }

    internal init(config: Config) {
        let plugin: StencilTemplate = .plugin
        stencils = [plugin]
        context = PluginContext(
            fileHeader: config.fileHeader,
            pluginName: config.variable("productName"),
            returnType: config.variable("returnType"),
            pluginImports: plugin.imports(config: config),
            includePeripheryIgnores: config.includePeripheryIgnores
        )
    }
}
