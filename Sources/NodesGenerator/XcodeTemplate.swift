//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal protocol XcodeTemplate {

    typealias PropertyList = XcodeTemplatePropertyList
    typealias Option = PropertyList.Option

    var name: String { get }
    var propertyList: PropertyList { get }
    var permutations: [XcodeTemplatePermutation] { get }
}
