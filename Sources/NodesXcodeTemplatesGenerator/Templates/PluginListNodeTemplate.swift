//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct PluginListNodeTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String = "Plugin List (for Node)"
    internal let stencils: [StencilTemplate]
    internal let context: Context

    internal let propertyList: PropertyList =
        .init(description: "The source file implementing a Plugin List.",
              sortOrder: 6) {
            Option(identifier: "productName",
                   name: "Plugin List name:",
                   description: "The name of the Plugin List")
        }

    internal init(config: Config) {
        let pluginList: StencilTemplate = .pluginList
        stencils = [pluginList]
        context = PluginListContext(
            fileHeader: config.fileHeader,
            pluginListName: config.variable("productName"),
            pluginListImports: pluginList.imports(config: config),
            viewControllableFlowType: config.viewControllableFlowType,
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled
        )
    }
}
