//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal protocol XcodeTemplate {

    typealias PropertyList = XcodeTemplatePropertyList
    typealias Option = PropertyList.Option

    var name: String { get }
    var stencils: [StencilTemplate] { get }
    var context: Context { get }
    var propertyList: PropertyList { get }
}
