//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

import NodesXcodeTemplatesGenerator

extension Array where Element == String {

    internal static func mock(with identifier: String, count: Int) -> Self {
        guard count > 0
        else { return [] }
        guard count > 1
        else { return ["<\(identifier)>"] }
        return (1...count).map { "<\(identifier)\($0)>" }
    }
}

extension Array where Element == XcodeTemplates.Config.Variable {

    internal static func mock(with identifier: String, count: Int) -> Self {
        guard count > 0
        else { return [] }
        guard count > 1
        else { return [XcodeTemplates.Config.Variable(name: "<\(identifier)Name>", type: "<\(identifier)Type>")] }
        return (1...count).map { count in
            XcodeTemplates.Config.Variable(name: "<\(identifier)Name\(count)>", type: "<\(identifier)Type\(count)>")
        }
    }
}
