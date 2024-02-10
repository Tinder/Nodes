//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal protocol XcodeTemplate {

    typealias PropertyList = XcodeTemplatePropertyList
    typealias Option = PropertyList.Option

    var name: String { get }
    var stencils: [StencilTemplate] { get }
    var stencilContext: StencilContext { get }
    var propertyList: PropertyList { get }
}

extension XcodeTemplate {

    internal static var productName: String {
        "productName"
    }

    internal static func variable(_ name: String) -> String {
        "___VARIABLE_\(name)___"
    }
}
