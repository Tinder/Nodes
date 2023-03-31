//
//  XcodeTemplates.swift
//  NodesXcodeTemplatesGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

import Foundation

public final class XcodeTemplates {

    private let templates: [XcodeTemplate]

    public init(config: Config) {
        var templates: [XcodeTemplate] = UIFramework.Kind
            .allCases
            .compactMap { try? NodeTemplate(for: $0, config: config) }
        if config.isViewInjectedNodeEnabled {
            templates.append(NodeViewInjectedTemplate(config: config))
        }
        templates += [
            PluginListNodeTemplate(config: config),
            PluginNodeTemplate(config: config),
            PluginTemplate(config: config),
            WorkerTemplate(config: config)
        ]
        self.templates = templates
    }

    public func generate(
        identifier: String,
        using fileSystem: FileSystem = FileManager.default
    ) throws {
        let url: URL = fileSystem.libraryURL
            .appendingPathComponent("Developer")
            .appendingPathComponent("Xcode")
            .appendingPathComponent("Templates")
            .appendingPathComponent("File Templates")
            .appendingPathComponent("Nodes Architecture Framework (\(identifier))")
        try? fileSystem.removeItem(at: url)
        try generate(at: url, using: fileSystem)
    }

    public func generate(
        at url: URL,
        using fileSystem: FileSystem = FileManager.default
    ) throws {
        let generator: XcodeTemplateGenerator = .init(fileSystem: fileSystem)
        try templates.forEach { try generator.generate(template: $0, into: url) }
    }
}
