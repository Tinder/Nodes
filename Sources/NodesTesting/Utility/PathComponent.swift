//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

internal class PathComponent: CustomStringConvertible {

    internal let description: String

    internal init<T>(for type: T.Type) {
        description = "\(type)"
            .components(separatedBy: ".")
            .reversed()[0]
    }
}
