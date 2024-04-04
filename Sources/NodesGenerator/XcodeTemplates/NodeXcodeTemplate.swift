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
                   name: "Node Name:",
                   description: "The name of the node.",
                   default: "MyFeatureV1")
            Option(identifier: XcodeTemplateConstants.uiFramework,
                   name: "UI Framework:",
                   description: "The UI framework of the new node.",
                   type: "popup",
                   values: uiFrameworks.map(\.name),
                   default: uiFrameworks.first?.name ?? "")
            Option(identifier: XcodeTemplateConstants.createdForPluginList,
                   name: "Created for existing Plugin List",
                   description: "Whether the node is created for use in an existing Plugin List.",
                   type: "checkbox",
                   default: "true")
            Option(identifier: XcodeTemplateConstants.pluginListName,
                   name: "Existing Plugin List:",
                   description: "The name of an existing Plugin List.",
                   requiredOptions: [XcodeTemplateConstants.createdForPluginList: ["true"]],
                   default: "MyFeature")
        }

        permutations = uiFrameworks.flatMap { framework in
            [
                NodeXcodeTemplatePermutation(createdForPluginList: true, for: framework, config: config),
                NodeXcodeTemplatePermutation(createdForPluginList: false, for: framework, config: config)
            ]
        }
    }
}
