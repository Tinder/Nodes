//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
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
                   description: "The UI framework of the node.",
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
                NodeXcodeTemplatePermutation(for: framework, createdForPluginList: true, config: config),
                NodeXcodeTemplatePermutation(for: framework, createdForPluginList: false, config: config)
            ]
        }
    }
}
