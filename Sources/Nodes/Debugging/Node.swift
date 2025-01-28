//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

#if DEBUG

public struct Node {

    public let name: String
    public let children: [Self]

    public init(name: String, children: [Self]) {
        self.name = name
        self.children = children
    }
}

#endif
