//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Foundation

public final class XcodeTemplates {

    private let config: Config
    private let fileSystem: FileSystem

    public init(
        config: Config,
        fileSystem: FileSystem = FileManager.default
    ) {
        self.config = config
        self.fileSystem = fileSystem
    }

    public func generate(
        identifier: String
    ) throws {
        let directory: URL = fileSystem.libraryURL
            .appendingPathComponent("Developer")
            .appendingPathComponent("Xcode")
            .appendingPathComponent("Templates")
            .appendingPathComponent("File Templates")
            .appendingPathComponent("Nodes Architecture Framework (\(identifier))")
        try? fileSystem.removeItem(at: directory)
        try generate(into: directory)
    }

    public func generate(
        into directory: URL
    ) throws {
        var seen: Set<String> = .init()
        let uiFrameworks: [UIFramework] = config.uiFrameworks.filter { framework in
            guard !seen.contains(framework.name)
            else { return false }
            seen.insert(framework.name)
            return true
        }
        let viewInjectedTemplate: [XcodeTemplate] = config
            .isViewInjectedTemplateEnabled ? [NodeViewInjectedXcodeTemplate(config: config)] : []
        let templates: [XcodeTemplate] = [
            NodeXcodeTemplate(uiFrameworks: uiFrameworks, config: config)
        ] + viewInjectedTemplate + [
            PluginListXcodeTemplate(config: config),
            PluginXcodeTemplate(config: config),
            WorkerXcodeTemplate(config: config)
        ]
        let generator: XcodeTemplateGenerator = .init(fileSystem: fileSystem)
        try templates.forEach { try generator.generate(template: $0, into: directory) }
    }
}
