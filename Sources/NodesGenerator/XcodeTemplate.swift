//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

internal protocol XcodeTemplate {

    typealias PropertyList = XcodeTemplatePropertyList
    typealias Option = PropertyList.Option

    var name: String { get }
    var propertyList: PropertyList { get }
    var permutations: [XcodeTemplatePermutation] { get }
}
