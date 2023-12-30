//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import ArgumentParser
import NodesXcodeTemplatesGenerator

@main
internal struct NodesXcodeTemplatesGeneratorCommand: ParsableCommand {

    internal static let configuration: CommandConfiguration = .init(commandName: "nodes-xcode-templates-gen",
                                                                    abstract: "Nodes Xcode Templates Generator")

    @Option(name: .customLong("id"), help: "The Xcode templates identifier.")
    private var identifier: String

    @Option(name: .customLong("config"), help: "The YAML config file path. (optional)")
    private var configPath: String?

    internal func run() throws {
        let config: Config = try configPath.flatMap { try Config(at: $0) } ?? Config()
        try XcodeTemplates(config: config).generate(identifier: identifier)
    }
}
