//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct PluginNodeXcodeTemplate: XcodeTemplate {

    internal let name: String = "Plugin (for Node)"
    internal let stencils: [StencilTemplate]
    internal let stencilContext: StencilContext

    internal let propertyList: PropertyList =
        .init(description: "The source file implementing a Plugin for a Node.",
              sortOrder: 7) {
            Option(identifier: XcodeTemplateConstants.productName,
                   name: "Node name:",
                   description: "The name of the Plugin")
        }

    internal init(config: Config) {
        let plugin: StencilTemplate = .plugin
        let pluginTests: StencilTemplate = .pluginTests
        let additional: [StencilTemplate] = config.isTestTemplatesGenerationEnabled ? [pluginTests] : []
        stencils = [plugin] + additional
        stencilContext = PluginStencilContext(
            fileHeader: config.fileHeader,
            pluginName: XcodeTemplateConstants.variable(XcodeTemplateConstants.productName),
            pluginImports: plugin.imports(config: config),
            pluginTestsImports: pluginTests.imports(config: config),
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled,
            isNimbleEnabled: config.isNimbleEnabled
        )
    }
}
