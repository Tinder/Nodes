//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct NodeXcodeTemplate: XcodeTemplate {

    internal let name: String
    internal let propertyList: PropertyList
    internal let permutations: [XcodeTemplatePermutation]

    internal init(for uiFramework: UIFramework, config: Config) {
        name = "Node - \(uiFramework.name)"
        // swiftlint:disable:next force_unwrapping
        propertyList = PropertyList(sortOrder: UIFramework.Kind.allCases.firstIndex(of: uiFramework.kind)! + 2) {
            Option(identifier: XcodeTemplateConstants.productName,
                   name: "Node name:",
                   description: "The name of the Node")
        }
        permutations = [NodeXcodeTemplatePermutation(name: name, for: uiFramework, config: config)]
    }
}
