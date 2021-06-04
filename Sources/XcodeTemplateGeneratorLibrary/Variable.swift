//
//  Variable.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 6/3/21.
//

extension XcodeTemplates {

    public struct Variable: Equatable, Decodable {

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
