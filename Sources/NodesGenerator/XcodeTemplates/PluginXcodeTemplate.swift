//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct PluginXcodeTemplate: XcodeTemplate {

    internal let name: String = "Plugin"

    internal let propertyList: PropertyList =
        .init(description: "The source file implementing a Plugin.",
              sortOrder: 9) {
            Option(identifier: XcodeTemplateConstants.productName,
                   name: "Plugin name:",
                   description: "The name of the Plugin")
            Option(identifier: "returnType",
                   name: "Plugin return type:",
                   description: "The return type of the Plugin")
        }

    internal let permutations: [XcodeTemplatePermutation]

    internal init(config: Config) {
        permutations = [PluginXcodeTemplatePermutation(name: name, config: config)]
    }
}
