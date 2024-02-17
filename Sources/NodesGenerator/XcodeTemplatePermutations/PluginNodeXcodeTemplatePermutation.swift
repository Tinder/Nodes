//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

internal struct PluginNodeXcodeTemplatePermutation: XcodeTemplatePermutation {

    internal let name: String
    internal let stencils: [StencilTemplate]
    internal let stencilContext: StencilContext

    internal init(name: String, config: Config) {
        self.name = name
        let plugin: StencilTemplate = .plugin
        stencils = [plugin]
        stencilContext = PluginStencilContext(
            fileHeader: config.fileHeader,
            pluginName: XcodeTemplateConstants.variable(XcodeTemplateConstants.productName),
            pluginImports: plugin.imports(config: config),
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled
        )
    }
}
