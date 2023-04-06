//
//  ConfigFactory.swift
//  NodesXcodeTemplatesGeneratorExecutable
//
//  Created by Christopher Fuller on 6/12/21.
//

import NodesXcodeTemplatesGenerator

internal final class ConfigFactory {

    internal typealias Config = XcodeTemplates.Config

    internal func callAsFunction(at path: String?) throws -> Config {
        guard let path = path
        else { return Config() }
        return try Config(at: path)
    }
}
