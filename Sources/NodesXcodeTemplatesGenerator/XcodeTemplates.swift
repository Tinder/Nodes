//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Foundation

public final class XcodeTemplates {

    private let templates: [XcodeTemplate]

    public init(config: Config) {
        var templates: [XcodeTemplate] = UIFramework.Kind
            .allCases
            .compactMap { try? NodeXcodeTemplate(for: $0, config: config) }
        if config.isViewInjectedTemplateEnabled {
            templates.append(NodeViewInjectedXcodeTemplate(config: config))
        }
        templates += [
            PluginListNodeXcodeTemplate(config: config),
            PluginNodeXcodeTemplate(config: config),
            PluginXcodeTemplate(config: config),
            WorkerXcodeTemplate(config: config)
        ]
        self.templates = templates
    }

    public func generate(
        identifier: String,
        using fileSystem: FileSystem = FileManager.default
    ) throws {
        let directory: URL = fileSystem.libraryURL
            .appendingPathComponent("Developer")
            .appendingPathComponent("Xcode")
            .appendingPathComponent("Templates")
            .appendingPathComponent("File Templates")
            .appendingPathComponent("Nodes Architecture Framework (\(identifier))")
        try? fileSystem.removeItem(at: directory)
        try generate(into: directory, using: fileSystem)
    }

    public func generate(
        into directory: URL,
        using fileSystem: FileSystem = FileManager.default
    ) throws {
        let generator: XcodeTemplateGenerator = .init(fileSystem: fileSystem)
        try templates.forEach { try generator.generate(template: $0, into: directory) }
    }
}
