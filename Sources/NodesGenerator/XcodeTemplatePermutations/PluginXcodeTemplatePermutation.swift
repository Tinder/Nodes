//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

internal struct PluginXcodeTemplatePermutation: XcodeTemplatePermutation {

    internal let name: String
    internal let stencils: [StencilTemplate]
    internal let stencilContext: StencilContext

    internal init(name: String, config: Config) {
        self.name = name
        let plugin: StencilTemplate = .plugin
        let pluginTests: StencilTemplate = .pluginTests
        stencils = [plugin]
        stencilContext = PluginStencilContext(
            fileHeader: config.fileHeader,
            pluginName: XcodeTemplateConstants.variable(XcodeTemplateConstants.productName),
            returnType: XcodeTemplateConstants.variable("returnType"),
            pluginImports: plugin.imports(with: config),
            pluginTestsImports: pluginTests.imports(with: config),
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled,
            isNimbleEnabled: config.isNimbleEnabled
        )
    }
}
