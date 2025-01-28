//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

internal struct PluginListXcodeTemplatePermutation: XcodeTemplatePermutation {

    internal let name: String
    internal let stencils: [StencilTemplate]
    internal let stencilContext: StencilContext

    internal init(name: String, config: Config) {
        self.name = name
        let pluginList: StencilTemplate = .pluginList
        let pluginListTests: StencilTemplate = .pluginListTests
        stencils = [pluginList] + (config.isTestTemplatesGenerationEnabled ? [pluginListTests] : [])
        stencilContext = PluginListStencilContext(
            fileHeader: XcodeTemplateConstants.fileHeader,
            pluginListName: XcodeTemplateConstants.variable(XcodeTemplateConstants.productName),
            pluginListImports: pluginList.imports(with: config),
            pluginListTestsImports: pluginListTests.imports(with: config),
            viewControllableFlowType: config.viewControllableFlowType,
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled,
            isNimbleEnabled: config.isNimbleEnabled
        )
    }
}
