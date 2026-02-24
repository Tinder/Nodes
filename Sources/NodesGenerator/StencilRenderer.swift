//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Foundation
import Stencil

public final class StencilRenderer {

    public init() {}

    public func renderNode(
        context: NodeStencilContext,
        kind: UIFramework.Kind,
        includePlugin: Bool = false,
        includeTests: Bool = false
    ) throws -> [String: String] {
        let node: StencilTemplate.Node = .init(.variation(for: kind))
        let stencils: [StencilTemplate] = node.stencils(includePlugin: includePlugin, includeTests: includeTests)
        return try render(stencils: stencils, with: context.dictionary)
    }

    public func renderNodeViewInjected(
        context: NodeViewInjectedStencilContext,
        includePlugin: Bool = false,
        includeTests: Bool = false
    ) throws -> [String: String] {
        let node: StencilTemplate.NodeViewInjected = .init()
        let stencils: [StencilTemplate] = node.stencils(includePlugin: includePlugin, includeTests: includeTests)
        return try render(stencils: stencils, with: context.dictionary)
    }

    public func renderPlugin(
        context: PluginStencilContext,
        includeTests: Bool
    ) throws -> [String: String] {
        let additional: [StencilTemplate] = includeTests ? [.pluginTests] : []
        let stencils: [StencilTemplate] = [.plugin, .pluginInterface] + additional
        return try render(stencils: stencils, with: context.dictionary)
    }

    public func renderPluginList(
        context: PluginListStencilContext,
        includeTests: Bool
    ) throws -> [String: String] {
        let additional: [StencilTemplate] = includeTests ? [.pluginListTests] : []
        let stencils: [StencilTemplate] = [.pluginList, .pluginListInterface] + additional
        return try render(stencils: stencils, with: context.dictionary)
    }

    public func renderWorker(
        context: WorkerStencilContext,
        includeTests: Bool
    ) throws -> [String: String] {
        let additional: [StencilTemplate] = includeTests ? [.workerTests] : []
        let stencils: [StencilTemplate] = [.worker] + additional
        return try render(stencils: stencils, with: context.dictionary)
    }

    internal func render(
        _ stencil: StencilTemplate,
        with context: [String: Any]
    ) throws -> String {
        let resources: Resources = .init()
        // swiftlint:disable:next force_unwrapping
        let stencilURL: URL = resources.url(forResource: stencil.filename, withExtension: "stencil")!
        let template: String = try .init(contentsOf: stencilURL)
        let environment: Environment = .init(loader: DictionaryLoader(templates: [stencil.name: template]),
                                             extensions: stencilExtensions(),
                                             trimBehaviour: .smart)
        return try environment.renderTemplate(name: stencil.name, context: context)
    }

    private func render(
        stencils: [StencilTemplate],
        with context: [String: Any]
    ) throws -> [String: String] {
        try Dictionary(uniqueKeysWithValues: stencils.map { stencil in
            try (stencil.name, render(stencil, with: context))
        })
    }

    private func stencilExtensions() -> [Extension] {
        let stencilExtension: Extension = .init()
        stencilExtension.registerFilter("decapitalize") { value in
            guard let string = value as? String
            else { return value }
            return string.prefix(1).lowercased() + string.dropFirst()
        }
        return [stencilExtension]
    }
}
