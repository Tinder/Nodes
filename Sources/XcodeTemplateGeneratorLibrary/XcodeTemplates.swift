//
//  XcodeTemplates.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

import Foundation

public final class XcodeTemplates {

    private let templates: [XcodeTemplate]

    // swiftlint:disable:next cyclomatic_complexity
    public init(config: Config) {
        var templates: [XcodeTemplate] = []
        if config.includedTemplates.contains("Node") {
            templates.append(NodeTemplate(config: config))
        }
        if config.includedTemplates.contains("NodeSwiftUI") {
            templates.append(NodeTemplate(config: config, swiftUI: true))
        }
        if config.includedTemplates.contains("NodeWithoutViewState") {
            templates.append(NodeWithoutViewStateTemplate(config: config))
        }
        if config.includedTemplates.contains("NodeWithoutViewStateSwiftUI") {
            templates.append(NodeWithoutViewStateTemplate(config: config, swiftUI: true))
        }
        if config.includedTemplates.contains("NodeWithoutView") {
            templates.append(NodeWithoutViewTemplate(config: config))
        }
        if config.includedTemplates.contains("PluginListNode") {
            templates.append(PluginListNodeTemplate(config: config))
        }
        if config.includedTemplates.contains("PluginMapNode") {
            templates.append(PluginMapNodeTemplate(config: config))
        }
        if config.includedTemplates.contains("PluginNode") {
            templates.append(PluginNodeTemplate(config: config))
        }
        if config.includedTemplates.contains("Plugin") {
            templates.append(PluginTemplate(config: config))
        }
        if config.includedTemplates.contains("Worker") {
            templates.append(WorkerTemplate(config: config))
        }
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
            .appendingPathComponent("Tinder Nodes Architecture Framework (\(identifier))")
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
