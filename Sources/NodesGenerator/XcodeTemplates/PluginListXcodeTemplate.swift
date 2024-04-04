//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct PluginListXcodeTemplate: XcodeTemplate {

    internal let name: String = "Plugin List (for Node)"

    internal let propertyList: PropertyList =
        .init(sortOrder: 3) {
            Option(identifier: XcodeTemplateConstants.productName,
                   name: "Plugin List Name:",
                   description: "The name of the Plugin List.",
                   default: "MyFeature")
        }

    internal let permutations: [XcodeTemplatePermutation]

    internal init(config: Config) {
        permutations = [PluginListXcodeTemplatePermutation(name: name, config: config)]
    }
}
