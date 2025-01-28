//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

extension Config {

    public struct Variable: Codable, Equatable {

        public var name: String
        public var type: String

        internal var dictionary: [String: Any] {
            [ "name": name, "type": type ]
        }

        public init(name: String, type: String) {
            self.name = name
            self.type = type
        }
    }
}
