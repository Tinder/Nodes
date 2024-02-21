//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

internal struct NodeXcodeTemplateV2: XcodeTemplate {

    internal let name: String = "Node"
    internal let propertyList: PropertyList
    internal let permutations: [XcodeTemplatePermutation]

    internal init?(uiFrameworks: [UIFramework], config: Config) {
        guard let firstFramework = uiFrameworks.first
        else { return nil }

        let description: String = "A wizard-style template picker for creating a Node."
        propertyList = PropertyList(description: description, sortOrder: 10) {
            Option(identifier: "productName",
                   name: "Node name:",
                   description: "The name of the new node.",
                   default: "MyFeatureV1")
            Option(identifier: XcodeTemplateConstants.usePluginList,
                   name: "Created For Existing Plugin List",
                   description: "Whether the node is created for use in an existing plugin list.",
                   type: "checkbox",
                   default: "true")
            Option(identifier: XcodeTemplateConstants.pluginListName,
                   name: "Existing Plugin List:",
                   description: "The name of an existing plugin list.",
                   default: "MyFeature",
                   requiredOptions: [XcodeTemplateConstants.usePluginList: ["true"]])
            Option(identifier: "uiFramework",
                   name: "UI Framework:",
                   description: "The UI framework of the new node.",
                   type: "popup",
                   default: firstFramework.name,
                   values: uiFrameworks.map(\.framework).map(\.name))
        }

        permutations = uiFrameworks
            .flatMap { framework in
                [
                    NodeXcodeTemplateV2Permutation(usePluginList: true, for: framework, config: config),
                    NodeXcodeTemplateV2Permutation(usePluginList: false, for: framework, config: config)
                ]
            }
    }
}
