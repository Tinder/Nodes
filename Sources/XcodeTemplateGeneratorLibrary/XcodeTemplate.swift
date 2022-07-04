//
//  XcodeTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

internal protocol XcodeTemplate {

    typealias PropertyList = XcodeTemplatePropertyList
    typealias Option = PropertyList.Option

    var name: String { get }
    var stencils: [String] { get }
    var filenames: [String: String] { get }
    var context: Context { get }
    var propertyList: PropertyList { get }
}

extension XcodeTemplate {

    internal var filenames: [String: String] { [:] }
}
