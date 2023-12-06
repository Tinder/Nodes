//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct PluginXcodeTemplate: XcodeTemplate {

    internal let name: String = "Plugin"
    internal let stencils: [StencilTemplate]
    internal let stencilContext: StencilContext

    internal let propertyList: PropertyList =
        .init(description: "The source file implementing a Plugin.",
              sortOrder: 8) {
            Option(identifier: Self.productName,
                   name: "Plugin name:",
                   description: "The name of the Plugin")
            Option(identifier: "returnType",
                   name: "Plugin return type:",
                   description: "The return type of the Plugin")
        }

    internal init(config: Config) {
        let plugin: StencilTemplate = .plugin
        stencils = [plugin]
        stencilContext = PluginStencilContext(
            fileHeader: config.fileHeader,
            pluginName: Self.variable(Self.productName),
            returnType: Self.variable("returnType"),
            pluginImports: plugin.imports(config: config),
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled
        )
    }
}
