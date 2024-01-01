//
//  Copyright © 2021 Tinder (Match Group, LLC)
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
        let url: URL = fileSystem.libraryURL
            .appendingPathComponent("Developer")
            .appendingPathComponent("Xcode")
            .appendingPathComponent("Templates")
            .appendingPathComponent("File Templates")
            .appendingPathComponent("Nodes Architecture Framework (\(identifier))")
        try? fileSystem.removeItem(at: url)
        try generate(at: url)
    }

    public func generate(
        at url: URL
    ) throws {
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
        let generator: XcodeTemplateGenerator = .init(fileSystem: fileSystem)
        try templates.forEach { try generator.generate(template: $0, into: url) }
    }
}
