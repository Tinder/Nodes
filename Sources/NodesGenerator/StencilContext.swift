//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Foundation

public enum StencilContextError: LocalizedError, Equatable {

    case reservedNodeName(String)
    case invalidPreset(String)

    public var errorDescription: String? {
        switch self {
        case let .reservedNodeName(nodeName):
            return "ERROR: Reserved Node Name (\(nodeName))"
        case let .invalidPreset(preset):
            return "ERROR: Invalid Preset (\(preset))"
        }
    }
}

internal protocol StencilContext {

    var dictionary: [String: Any] { get }
}

extension Set where Element == String {

    internal func sortedImports() -> [Element] {
        func prepare(_ string: String) -> [String] {
            string
                .components(separatedBy: "//")[0]
                .trimmingCharacters(in: .whitespaces)
                .components(separatedBy: " ")
        }
        func compare(_ lhs: String, _ rhs: String) -> Bool {
            lhs.compare(rhs, options: [.caseInsensitive, .numeric]) == .orderedAscending
        }
        return self
            .filter { !$0.isEmpty }
            .sorted { lhs, rhs  in
                let lhs: [String] = prepare(lhs)
                let rhs: [String] = prepare(rhs)
                switch (lhs.count, rhs.count) {
                case (2, 2):
                    guard lhs[0] == rhs[0]
                    else { return compare(lhs[0], rhs[0]) }
                    return compare(lhs[1], rhs[1])
                case (2, 1):
                    return compare(lhs[1], rhs[0])
                case (1, 2):
                    return compare(lhs[0], rhs[1])
                default:
                    return compare(lhs[0], rhs[0])
                }
            }
    }
}
