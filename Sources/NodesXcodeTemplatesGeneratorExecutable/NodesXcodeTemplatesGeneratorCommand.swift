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
        let config: ConfigFactory = .init()
        try XcodeTemplates(config: config(at: configPath)).generate(identifier: identifier)
    }
}
