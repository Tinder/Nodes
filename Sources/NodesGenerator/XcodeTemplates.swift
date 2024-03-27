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
        let uiFrameworks: [UIFramework] = UIFramework.Kind
            .allCases
            .compactMap { try? config.uiFramework(for: $0) }
        var templates: [XcodeTemplate] = uiFrameworks
            .map { NodeXcodeTemplate(for: $0, config: config) }
        if let nodeXcodeTemplateV2: NodeXcodeTemplateV2 = .init(uiFrameworks: uiFrameworks, config: config) {
            templates.append(nodeXcodeTemplateV2)
        }
        if config.isViewInjectedTemplateEnabled {
            templates.append(NodeViewInjectedXcodeTemplate(config: config))
        }
        templates += [
            PluginListNodeXcodeTemplate(config: config),
            PluginNodeXcodeTemplate(config: config),
            WorkerXcodeTemplate(config: config)
        ]
        let generator: XcodeTemplateGenerator = .init(fileSystem: fileSystem)
        try templates.forEach { try generator.generate(template: $0, into: directory) }
    }
}
