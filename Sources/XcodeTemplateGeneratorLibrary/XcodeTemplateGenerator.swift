//
//  XcodeTemplateGenerator.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
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

    private func renderStencils(for template: XcodeTemplate, into url: URL) throws {
        let stencilRenderer: StencilRenderer = .init()
        try template.stencils.forEach {
            let contents: String = try stencilRenderer.render($0, with: template.context.dictionary)
            let url: URL = url
                .appendingPathComponent("___FILEBASENAME___\(template.filenames[$0.rawValue] ?? $0.rawValue)")
                .appendingPathExtension("swift")
            try fileSystem.write(Data(contents.utf8), to: url, atomically: true)
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
        let iconsURL: URL = bundle.resourceURL!.appendingPathComponent("Icons")
        try fileSystem.copyItem(at: iconsURL
                                    .appendingPathComponent("Tinder")
                                    .appendingPathExtension("png"),
                                to: url
                                    .appendingPathComponent("TemplateIcon")
                                    .appendingPathExtension("png"))
        try fileSystem.copyItem(at: iconsURL
                                    .appendingPathComponent("Tinder@2x")
                                    .appendingPathExtension("png"),
                                to: url
                                    .appendingPathComponent("TemplateIcon@2x")
                                    .appendingPathExtension("png"))
    }
}
