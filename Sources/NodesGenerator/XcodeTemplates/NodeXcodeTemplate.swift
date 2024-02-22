//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct NodeXcodeTemplate: XcodeTemplate {

    internal let name: String
    internal let propertyList: PropertyList
    internal let permutations: [XcodeTemplatePermutation]

    internal init(for kind: UIFramework.Kind, config: Config) throws {
        let uiFramework: UIFramework = try config.uiFramework(for: kind)
        name = "Node - \(uiFramework.name)"
        propertyList = PropertyList(description: "The source files implementing a Node.",
                                    // swiftlint:disable:next force_unwrapping
                                    sortOrder: UIFramework.Kind.allCases.firstIndex(of: uiFramework.kind)! + 2) {
            Option(identifier: XcodeTemplateConstants.productName,
                   name: "Node name:",
                   description: "The name of the Node")
        }
        permutations = [NodeXcodeTemplatePermutation(name: name, for: uiFramework, config: config)]
    }
}
