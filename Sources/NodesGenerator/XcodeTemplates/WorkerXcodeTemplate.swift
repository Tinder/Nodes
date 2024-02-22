//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct WorkerXcodeTemplate: XcodeTemplate {

    internal let name: String = "Worker"

    internal let propertyList: PropertyList =
        .init(description: "The source file implementing a Worker.",
              sortOrder: 10) {
            Option(identifier: XcodeTemplateConstants.productName,
                   name: "Worker name:",
                   description: "The name of the Worker")
        }

    internal let permutations: [XcodeTemplatePermutation]

    internal init(config: Config) {
        permutations = [WorkerXcodeTemplatePermutation(name: name, config: config)]
    }
}
