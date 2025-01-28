//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

internal struct WorkerXcodeTemplate: XcodeTemplate {

    internal let name: String = "Worker"

    internal let propertyList: PropertyList =
        .init(sortOrder: 5) {
            Option(identifier: XcodeTemplateConstants.productName,
                   name: "Worker Name:",
                   description: "The name of the Worker.")
        }

    internal let permutations: [XcodeTemplatePermutation]

    internal init(config: Config) {
        permutations = [WorkerXcodeTemplatePermutation(name: name, config: config)]
    }
}
