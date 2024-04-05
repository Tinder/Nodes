//
//  Copyright © 2021 Tinder (Match Group, LLC)
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
