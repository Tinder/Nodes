//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct PluginListNodeXcodeTemplate: XcodeTemplate {

    internal let name: String = "Plugin List (for Node)"
    internal let stencilTemplates: [StencilTemplate]
    internal let stencilContext: StencilContext

    internal let propertyList: PropertyList =
        .init(description: "The source file implementing a Plugin List.",
              sortOrder: 6) {
            Option(identifier: "productName",
                   name: "Plugin List name:",
                   description: "The name of the Plugin List")
        }

    internal init(config: Config) {
        let pluginList: StencilTemplate = .pluginList
        stencilTemplates = [pluginList]
        stencilContext = PluginListStencilContext(
            fileHeader: config.fileHeader,
            pluginListName: config.variable("productName"),
            pluginListImports: pluginList.imports(config: config),
            viewControllableFlowType: config.viewControllableFlowType,
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled
        )
    }
}
