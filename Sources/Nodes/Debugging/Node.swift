//
//  Copyright © 2024 Tinder (Match Group, LLC)
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
