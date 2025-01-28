//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

extension Set where Element == String {

    internal static func mock(with identifier: String, count: Int) -> Self {
        let strings: [String] = .mock(with: identifier, count: count)
        return Set(strings)
    }
}
