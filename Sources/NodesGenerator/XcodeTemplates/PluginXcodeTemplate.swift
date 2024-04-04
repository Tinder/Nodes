//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct PluginXcodeTemplate: XcodeTemplate {

    internal let name: String = "Plugin"

    internal let propertyList: PropertyList =
        .init(sortOrder: 4) {
            Option(identifier: XcodeTemplateConstants.productName,
                   name: "Node name:",
                   description: "The name of the Plugin")
        }

    internal let permutations: [XcodeTemplatePermutation]

    internal init(config: Config) {
        permutations = [PluginXcodeTemplatePermutation(name: name, config: config)]
    }
}
