//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Foundation

internal final class XcodeTemplateGenerator {

    private let fileSystem: FileSystem

    internal init(fileSystem: FileSystem) {
        self.fileSystem = fileSystem
    }

    internal func generate(template: XcodeTemplate, into directory: URL) throws {
        let url: URL = directory
            .appendingPathComponent(template.name)
            .appendingPathExtension("xctemplate")
        try? fileSystem.removeItem(at: url)
        try fileSystem.createDirectory(at: url, withIntermediateDirectories: true)
        try renderStencils(for: template, into: url)
        try writePropertyList(for: template, into: url)
        try copyIcons(into: url)
    }

    private func renderStencils(for template: XcodeTemplate, into directory: URL) throws {
        let stencilRenderer: StencilRenderer = .init()
        let permutations: [XcodeTemplatePermutation] = template.permutations
        if permutations.count == 1, let permutation: XcodeTemplatePermutation = permutations.first {
            for stencil: StencilTemplate in permutation.stencils {
                let contents: String = try stencilRenderer.render(stencil, with: permutation.stencilContext.dictionary)
                let url: URL = directory
                    .appendingPathComponent("\(XcodeTemplateConstants.fileBaseName)\(stencil.name)")
                    .appendingPathExtension("swift")
                try fileSystem.write(Data(contents.utf8), to: url, atomically: true)
            }
        } else {
            for permutation: XcodeTemplatePermutation in permutations {
                let directory: URL = directory.appendingPathComponent(permutation.name)
                try fileSystem.createDirectory(at: directory, withIntermediateDirectories: true)

                for stencil: StencilTemplate in permutation.stencils {
                    let stencilDirectory: URL = directory
                        .appendingPathComponent("\(XcodeTemplateConstants.fileBaseName)\(stencil.name)")
                        .appendingPathExtension("swift")
                    let contents: String = try stencilRenderer.render(stencil,
                                                                      with: permutation.stencilContext.dictionary)
                    try fileSystem.write(Data(contents.utf8), to: stencilDirectory, atomically: true)
                }
            }
        }
    }

    private func writePropertyList(for template: XcodeTemplate, into directory: URL) throws {
        try fileSystem.write(template.propertyList.encode(),
                             to: directory
                                .appendingPathComponent("TemplateInfo")
                                .appendingPathExtension("plist"),
                             atomically: true)
    }

    private func copyIcons(into directory: URL) throws {
        let resources: Resources = .init()
        // swiftlint:disable:next force_unwrapping
        try fileSystem.copyItem(at: resources.url(forResource: "Tinder", withExtension: "png")!,
                                to: directory
                                    .appendingPathComponent("TemplateIcon")
                                    .appendingPathExtension("png"))
        // swiftlint:disable:next force_unwrapping
        try fileSystem.copyItem(at: resources.url(forResource: "Tinder@2x", withExtension: "png")!,
                                to: directory
                                    .appendingPathComponent("TemplateIcon@2x")
                                    .appendingPathExtension("png"))
    }
}
