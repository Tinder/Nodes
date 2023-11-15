//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

extension XcodeTemplates.Config {

    public struct Variable: Equatable, Codable {

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
