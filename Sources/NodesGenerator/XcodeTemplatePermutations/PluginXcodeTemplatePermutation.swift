//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

internal struct PluginXcodeTemplatePermutation: XcodeTemplatePermutation {

    internal let name: String
    internal let stencils: [StencilTemplate]
    internal let stencilContext: StencilContext

    internal init(name: String, config: Config) {
        self.name = name
        let plugin: StencilTemplate = .plugin
        let pluginTests: StencilTemplate = .pluginTests
        stencils = [plugin] + (config.isTestTemplatesGenerationEnabled ? [pluginTests] : [])
        stencilContext = PluginStencilContext(
            fileHeader: XcodeTemplateConstants.fileHeader,
            pluginName: XcodeTemplateConstants.variable(XcodeTemplateConstants.productName),
            pluginImports: plugin.imports(with: config),
            pluginTestsImports: pluginTests.imports(with: config),
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled,
            isNimbleEnabled: config.isNimbleEnabled
        )
    }
}
