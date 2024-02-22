//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct PluginListNodeXcodeTemplate: XcodeTemplate {

    internal let name: String = "Plugin List (for Node)"

    internal let propertyList: PropertyList =
        .init(description: "The source file implementing a Plugin List.",
              sortOrder: 7) {
            Option(identifier: XcodeTemplateConstants.productName,
                   name: "Plugin List name:",
                   description: "The name of the Plugin List",
                   default: "MyFeature")
        }

    internal let permutations: [XcodeTemplatePermutation]

    internal init(config: Config) {
        permutations = [PluginListNodeXcodeTemplatePermutation(name: name, config: config)]
    }
}
