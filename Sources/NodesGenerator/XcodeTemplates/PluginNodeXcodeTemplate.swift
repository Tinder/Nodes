//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct PluginNodeXcodeTemplate: XcodeTemplate {

    internal let name: String = "Plugin (for Node)"

    internal let propertyList: PropertyList =
        .init(sortOrder: 4) {
            Option(identifier: XcodeTemplateConstants.productName,
                   name: "Node name:",
                   description: "The name of the Plugin")
        }

    internal let permutations: [XcodeTemplatePermutation]

    internal init(config: Config) {
        permutations = [PluginNodeXcodeTemplatePermutation(name: name, config: config)]
    }
}
