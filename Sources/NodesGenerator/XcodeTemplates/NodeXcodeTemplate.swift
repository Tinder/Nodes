//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

internal struct NodeXcodeTemplate: XcodeTemplate {

    internal let name: String = "Node"
    internal let propertyList: PropertyList
    internal let permutations: [XcodeTemplatePermutation]

    internal init(uiFrameworks: [UIFramework], config: Config) {
        propertyList = PropertyList(sortOrder: 1) {
            Option(identifier: XcodeTemplateConstants.productName,
                   name: "Node name:",
                   description: "The name of the new node.",
                   default: "MyFeatureV1")
            Option(identifier: XcodeTemplateConstants.uiFramework,
                   name: "UI Framework:",
                   description: "The UI framework of the new node.",
                   type: "popup",
                   values: uiFrameworks.map(\.name),
                   default: uiFrameworks.first?.name ?? "")
            Option(identifier: XcodeTemplateConstants.usePluginList,
                   name: "Created For Existing Plugin List",
                   description: "Whether the node is created for use in an existing plugin list.",
                   type: "checkbox",
                   default: "true")
            Option(identifier: XcodeTemplateConstants.pluginListName,
                   name: "Existing Plugin List:",
                   description: "The name of an existing plugin list.",
                   requiredOptions: [XcodeTemplateConstants.usePluginList: ["true"]],
                   default: "MyFeature")
        }

        permutations = uiFrameworks.flatMap { framework in
            [
                NodeXcodeTemplatePermutation(usePluginList: true, for: framework, config: config),
                NodeXcodeTemplatePermutation(usePluginList: false, for: framework, config: config)
            ]
        }
    }
}
