//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import NodesXcodeTemplatesGenerator

internal final class ConfigFactory {

    internal func callAsFunction(at path: String?) throws -> Config {
        guard let path: String
        else { return Config() }
        return try Config(at: path)
    }
}
