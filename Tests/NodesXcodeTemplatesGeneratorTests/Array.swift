//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

import NodesXcodeTemplatesGenerator

extension Array where Element == XcodeTemplates.Variable {

    internal static func mock(with identifier: String, count: Int) -> [Element] {
        guard count > 0
        else { return [] }
        guard count > 1
        else { return [Element(name: "<\(identifier)Name>", type: "<\(identifier)Type>")] }
        return (1...count).map { Element(name: "<\(identifier)Name\($0)>", type: "<\(identifier)Type\($0)>") }
    }
}
