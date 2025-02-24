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
        return switch count {
        case 1:
            [
                "<\(identifier)>"
            ]
        default:
            (1...count).map { index in
                "<\(identifier)\(index)>"
            }
        }
    }
}

extension Array where Element == Config.Variable {

    internal static func mock(with identifier: String, count: Int) -> Self {
        guard count > 0
        else { return [] }
        return switch count {
        case 1:
            [
                Config.Variable(
                    name: "<\(identifier)Name>",
                    type: "<\(identifier)Type>"
                )
            ]
        default:
            (1...count).map { index in
                Config.Variable(
                    name: "<\(identifier)Name\(index)>",
                    type: "<\(identifier)Type\(index)>"
                )
            }
        }
    }
}
