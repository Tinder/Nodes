//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct NodeViewInjectedXcodeTemplate: XcodeTemplate {

    internal let name: String = "Node (view injected)"

    internal let propertyList: PropertyList =
        .init(description: "The source files implementing a Node.",
              sortOrder: 6) {
            Option(identifier: XcodeTemplateConstants.productName,
                   name: "Node name:",
                   description: "The name of the Node")
        }

    internal let permutations: [XcodeTemplatePermutation]

    internal init(config: Config) {
        permutations = [NodeViewInjectedXcodeTemplatePermutation(name: name, config: config)]
    }
}
