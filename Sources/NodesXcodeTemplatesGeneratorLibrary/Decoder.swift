//
//  Decoder.swift
//  NodesXcodeTemplatesGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/18/22.
//

// Workaround for https://github.com/jpsim/Yams/issues/301
extension Decoder {

    internal func decodeString<K: CodingKey>(_ key: K) throws -> String {
        try decode(key, as: String.self)
    }
}
