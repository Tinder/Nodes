//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

internal struct PluginListXcodeTemplate: XcodeTemplate {

    internal let name: String = "Plugin List"

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
