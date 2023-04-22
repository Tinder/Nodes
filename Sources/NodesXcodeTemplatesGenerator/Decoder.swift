//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

// Workaround for https://github.com/jpsim/Yams/issues/301
extension Decoder {

    internal func decodeString<K: CodingKey>(_ key: K) throws -> String {
        try decode(key, as: String.self)
    }
}
