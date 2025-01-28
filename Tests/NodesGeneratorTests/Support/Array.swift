//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import NodesGenerator

extension Array where Element == String {

    internal static func mock(with identifier: String, count: Int) -> Self {
        guard count > 0
        else { return [] }
        guard count > 1
        else { return ["<\(identifier)>"] }
        return (1...count).map { "<\(identifier)\($0)>" }
    }
}

extension Array where Element == Config.Variable {

    internal static func mock(with identifier: String, count: Int) -> Self {
        guard count > 0
        else { return [] }
        guard count > 1
        else { return [Config.Variable(name: "<\(identifier)Name>", type: "<\(identifier)Type>")] }
        return (1...count).map { count in
            Config.Variable(name: "<\(identifier)Name\(count)>", type: "<\(identifier)Type\(count)>")
        }
    }
}
