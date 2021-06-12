//
//  XcodeTemplateGeneratorCommand.swift
//  XcodeTemplateGeneratorTool
//
//  Created by Christopher Fuller on 4/25/21.
//

import ArgumentParser
import XcodeTemplateGeneratorLibrary

@main
internal struct XcodeTemplateGeneratorCommand: ParsableCommand {

    internal static var configuration: CommandConfiguration = .init(commandName: "xc-template-generator",
                                                                    abstract: "Xcode Template Generator")

    // The Xcode templates identifier
    @Option(name: .customLong("id"), help: "The Xcode templates identifier.")
    private var identifier: String

    // The YAML config file path. (optional)
    @Option(name: .customLong("config"), help: "The YAML config file path. (optional)")
    private var path: String?

    internal func run() throws {
        try XcodeTemplates(config: config()).generate(identifier: identifier)
    }

    private func config() throws -> XcodeTemplates.Config {
        guard let path = path
        else { return XcodeTemplates.Config() }
        return try XcodeTemplates.Config(at: path)
    }
}
