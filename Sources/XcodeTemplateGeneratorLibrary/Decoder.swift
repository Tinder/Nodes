//
//  DecoderExtensions.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/18/22.
//

extension Decoder {

    // Workaround for https://github.com/jpsim/Yams/issues/301
    internal func decodeString(_ key: String) throws -> String {
        try decode(key, as: String.self)
    }

    // Workaround for https://github.com/jpsim/Yams/issues/301
    internal func decodeString<K: CodingKey>(_ key: K) throws -> String {
        try decode(key, as: String.self)
    }
}
