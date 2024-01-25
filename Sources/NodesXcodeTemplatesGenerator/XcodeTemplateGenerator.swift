//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Foundation

internal final class XcodeTemplateGenerator {

    private let fileSystem: FileSystem

    internal init(fileSystem: FileSystem) {
        self.fileSystem = fileSystem
    }

    internal func generate(template: XcodeTemplate, into url: URL) throws {
        let url: URL = url
            .appendingPathComponent(template.name)
            .appendingPathExtension("xctemplate")
        try? fileSystem.removeItem(at: url)
        try fileSystem.createDirectory(at: url, withIntermediateDirectories: true)
        try renderStencils(for: template, into: url)
        try writePropertyList(for: template, into: url)
        try copyIcons(into: url)
    }

    internal func generate(wizard: NodeWizardTemplate, into url: URL) throws {
        let url: URL = url
            .appendingPathComponent("Node Wizard")
            .appendingPathExtension("xctemplate")
        try? fileSystem.removeItem(at: url)
        try fileSystem.createDirectory(at: url, withIntermediateDirectories: true)
        try fileSystem.write(wizard.propertyList.encode(),
                             to: url
            .appendingPathComponent("TemplateInfo")
            .appendingPathExtension("plist"),
                             atomically: true)
        try copyIcons(into: url)
        try wizard.variations.forEach {
            try render(variation: $0, at: url)
        }
    }

    private func render(variation: NodeWizardTemplate.Variation, at url: URL) throws {
        switch variation {
        case let .pluginList(name, pluginList, plugin, node):
            try renderPluginList(variationName: name, pluginList: pluginList, plugin: plugin, node: node, url: url)
        case let .plugin(name, plugin, node):
            try renderPlugin(variationName: name, plugin: plugin, node: node, url: url)
        case let .builder(name, node):
            try renderNode(variationName: name, node: node, url: url)
        }
    }

    private func renderPluginList(
        variationName: String,
        pluginList: PluginListNodeXcodeTemplate,
        plugin: PluginNodeXcodeTemplate,
        node: NodeWizardTemplate.ViewVariation,
        url: URL
    ) throws {
        let stencilRenderer: StencilRenderer = .init()
        let variationPath: URL = url.appendingPathComponent(variationName, isDirectory: true)
        try fileSystem.createDirectory(at: variationPath, withIntermediateDirectories: false)
        let nodePath = variationPath.appendingPathComponent("___VARIABLE_productName___", isDirectory: true)
        try fileSystem.createDirectory(at: nodePath, withIntermediateDirectories: false)
        try pluginList.stencils.forEach { stencil in
            let contents: String = try stencilRenderer.render(stencil, with: pluginList.stencilContext.dictionary)
            try fileSystem.write(Data(contents.utf8),
                                 to: nodePath
                .appendingPathComponent("___VARIABLE_productName___PluginList")
                .appendingPathExtension("swift"),
                                 atomically: true)
        }
        let nodeVariantPath: URL = nodePath.appendingPathComponent("___VARIABLE_productName______VARIABLE_suffix___", isDirectory: true)
        try fileSystem.createDirectory(at: nodeVariantPath, withIntermediateDirectories: false)
        try plugin.stencils.forEach { stencil in
            let contents: String = try stencilRenderer.render(stencil, with: plugin.stencilContext.dictionary)
            try fileSystem.write(Data(contents.utf8),
                                 to: nodeVariantPath
                .appendingPathComponent("___FILEBASENAME______VARIABLE_suffix___\(stencil.name)")
                .appendingPathExtension("swift"),
                                 atomically: true)
        }
        try node.template.stencils.forEach { stencil in
            let contents: String = try stencilRenderer.render(stencil, with: node.template.stencilContext.dictionary)
            try fileSystem.write(Data(contents.utf8),
                                 to: nodeVariantPath
                .appendingPathComponent("___FILEBASENAME______VARIABLE_suffix___\(stencil.name)")
                .appendingPathExtension("swift"),
                                 atomically: true)
        }
    }

    private func renderPlugin(
        variationName: String,
        plugin: PluginNodeXcodeTemplate,
        node: NodeWizardTemplate.ViewVariation,
        url: URL
    ) throws {
        let stencilRenderer: StencilRenderer = .init()
        let variationPath: URL = url.appendingPathComponent(variationName, isDirectory: true)
        try fileSystem.createDirectory(at: variationPath, withIntermediateDirectories: false)
        try plugin.stencils.forEach { stencil in
            let contents: String = try stencilRenderer.render(stencil, with: plugin.stencilContext.dictionary)
            try fileSystem.write(Data(contents.utf8),
                                 to: variationPath
                .appendingPathComponent("___FILEBASENAME___\(stencil.name)")
                .appendingPathExtension("swift"),
                                 atomically: true)
        }
        try node.template.stencils.forEach { stencil in
            let contents: String = try stencilRenderer.render(stencil, with: node.template.stencilContext.dictionary)
            try fileSystem.write(Data(contents.utf8),
                                 to: variationPath
                .appendingPathComponent("___FILEBASENAME___\(stencil.name)")
                .appendingPathExtension("swift"),
                                 atomically: true)
        }
    }

    private func renderNode(
        variationName: String,
        node: NodeWizardTemplate.ViewVariation,
        url: URL
    ) throws {
        let stencilRenderer: StencilRenderer = .init()
        let variationPath: URL = url.appendingPathComponent(variationName, isDirectory: true)
        try fileSystem.createDirectory(at: variationPath, withIntermediateDirectories: false)
        try node.template.stencils.forEach { stencil in
            let contents: String = try stencilRenderer.render(stencil, with: node.template.stencilContext.dictionary)
            try fileSystem.write(Data(contents.utf8),
                                 to: variationPath
                .appendingPathComponent("___FILEBASENAME___\(stencil.name)")
                .appendingPathExtension("swift"),
                                 atomically: true)
        }
    }

    private func renderStencils(for template: XcodeTemplate, into url: URL) throws {
        let stencilRenderer: StencilRenderer = .init()
        try template.stencils.forEach { stencil in
            let contents: String = try stencilRenderer.render(stencil, with: template.stencilContext.dictionary)
            try fileSystem.write(Data(contents.utf8),
                                 to: url
                .appendingPathComponent("___FILEBASENAME___\(stencil.name)")
                .appendingPathExtension("swift"),
                                 atomically: true)
        }
    }

    private func writePropertyList(for template: XcodeTemplate, into url: URL) throws {
        try fileSystem.write(template.propertyList.encode(),
                             to: url
            .appendingPathComponent("TemplateInfo")
            .appendingPathExtension("plist"),
                             atomically: true)
    }

    private func copyIcons(into url: URL) throws {
        let bundle: Bundle = .moduleRelativeToExecutable ?? .module
        // swiftlint:disable:next force_unwrapping
        try fileSystem.copyItem(at: bundle.url(forResource: "Tinder", withExtension: "png")!,
                                to: url
            .appendingPathComponent("TemplateIcon")
            .appendingPathExtension("png"))
        // swiftlint:disable:next force_unwrapping
        try fileSystem.copyItem(at: bundle.url(forResource: "Tinder@2x", withExtension: "png")!,
                                to: url
            .appendingPathComponent("TemplateIcon@2x")
            .appendingPathExtension("png"))
    }
}
