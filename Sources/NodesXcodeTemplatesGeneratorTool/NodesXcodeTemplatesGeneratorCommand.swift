//
//  NodesXcodeTemplatesGeneratorCommand.swift
//  NodesXcodeTemplatesGeneratorTool
//
//  Created by Christopher Fuller on 4/25/21.
//

import ArgumentParser
import NodesXcodeTemplatesGeneratorLibrary

@main
internal struct NodesXcodeTemplatesGeneratorCommand: ParsableCommand {

    internal static let configuration: CommandConfiguration = .init(commandName: "nodes-xcode-templates-gen",
                                                                    abstract: "Nodes Xcode Templates Generator")

    @Option(name: .customLong("id"),
            help: "The Xcode templates identifier.")

    private var identifier: String

    @Option(name: .customLong("config"),
            help: "The YAML config file path. (optional)")

    private var path: String?

    internal func run() throws {
        let config: ConfigFactory = .init()
        try XcodeTemplates(config: config(at: path)).generate(identifier: identifier)
    }
}
