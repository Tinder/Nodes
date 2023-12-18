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
