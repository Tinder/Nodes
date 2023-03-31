//
//  XcodeTemplate.swift
//  NodesXcodeTemplatesGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

internal protocol XcodeTemplate {

    typealias PropertyList = XcodeTemplatePropertyList
    typealias Option = PropertyList.Option

    var name: String { get }
    var stencils: [StencilTemplate] { get }
    var context: Context { get }
    var propertyList: PropertyList { get }
}
