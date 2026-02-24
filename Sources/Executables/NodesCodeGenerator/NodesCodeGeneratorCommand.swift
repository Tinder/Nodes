//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import ArgumentParser
import Foundation
import NodesGenerator

@main
internal struct NodesCodeGeneratorCommand: ParsableCommand {

    internal static let configuration: CommandConfiguration = .init(
        commandName: "nodes-code-gen",
        abstract: "Nodes Code Generator"
    )

    @Option(help: "The name of the preset. (App|Scene|Window|Root)")
    private var preset: Preset

    @Option(help: "The name of the author for the file header.")
    private var author: String

    @Option(name: .customLong("path"), help: "The output path.")
    private var outputPath: String

    @Option(name: .customLong("config"), help: "The YAML config file path. (optional)")
    private var configPath: String?

    internal func run() throws {
        let config: Config = try configPath.flatMap { try Config(at: $0) } ?? Config()
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateStyle = .short
        let fileHeader: String = "\n//  Created by \(author) on \(dateFormatter.string(from: Date())).\n//"
        let directory: URL = .init(fileURLWithPath: outputPath)
        try PresetGenerator(config: config).generate(preset: preset, with: fileHeader, into: directory)
    }
}

extension Preset: ExpressibleByArgument {}
