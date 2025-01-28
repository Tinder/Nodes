//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import ArgumentParser
import NodesGenerator

@main
internal struct NodesXcodeTemplatesGeneratorCommand: ParsableCommand {

    #if swift(>=5.10)
    nonisolated(unsafe) internal static let configuration: CommandConfiguration = .init(
        commandName: "nodes-xcode-templates-gen",
        abstract: "Nodes Xcode Templates Generator"
    )
    #else
    internal static let configuration: CommandConfiguration = .init(
        commandName: "nodes-xcode-templates-gen",
        abstract: "Nodes Xcode Templates Generator"
    )
    #endif

    @Option(name: .customLong("id"), help: "The Xcode templates identifier.")
    private var identifier: String

    @Option(name: .customLong("config"), help: "The YAML config file path. (optional)")
    private var configPath: String?

    internal func run() throws {
        let config: Config = try configPath.flatMap { try Config(at: $0) } ?? Config()
        try XcodeTemplates(config: config).generate(identifier: identifier)
    }
}
