//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

internal struct NodeViewInjectedXcodeTemplate: XcodeTemplate {

    internal let name: String = "View Injected"

    internal let propertyList: PropertyList =
        .init(sortOrder: 2) {
            Option(identifier: XcodeTemplateConstants.productName,
                   name: "Node Name:",
                   description: "The name of the node.")
        }

    internal let permutations: [XcodeTemplatePermutation]

    internal init(config: Config) {
        permutations = [NodeViewInjectedXcodeTemplatePermutation(name: name, config: config)]
    }
}
