//
//  XcodeTemplates.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

import Foundation

public final class XcodeTemplates {

    private let templates: [XcodeTemplate]

    public init(config: Config) {
        var templates: [XcodeTemplate] = []
        if config.includedTemplates.contains(.node) {
            templates.append(NodeTemplate(config: config))
        }
        if config.includedTemplates.contains(.nodeSwiftUI) {
            templates.append(NodeTemplate(config: config, swiftUI: true))
        }
        if config.includedTemplates.contains(.nodeViewInjected) {
            templates.append(NodeViewInjectedTemplate(config: config))
        }
        if config.includedTemplates.contains(.pluginListNode) {
            templates.append(PluginListNodeTemplate(config: config))
        }
        if config.includedTemplates.contains(.pluginNode) {
            templates.append(PluginNodeTemplate(config: config))
        }
        if config.includedTemplates.contains(.plugin) {
            templates.append(PluginTemplate(config: config))
        }
        if config.includedTemplates.contains(.worker) {
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
