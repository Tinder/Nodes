//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Foundation
import Stencil

public final class StencilRenderer {

    public init() {}

    public func renderNode(
        context: NodeStencilContext,
        kind: UIFramework.Kind,
        includeState: Bool = true,
        includeTests: Bool = false
    ) throws -> [String: String] {
        let node: StencilTemplate.Node = .init(for: .variation(for: kind))
        let stencils: [StencilTemplate] = node.stencils(includeState: includeState,
                                                        includeTests: includeTests)
        return try render(stencils: stencils, with: context.dictionary)
    }

    public func renderNodeViewInjected(
        context: NodeViewInjectedStencilContext,
        includeState: Bool = true,
        includeTests: Bool = false
    ) throws -> [String: String] {
        let nodeViewInjected: StencilTemplate.NodeViewInjected = .init()
        let stencils: [StencilTemplate] = nodeViewInjected.stencils(includeState: includeState,
                                                                    includeTests: includeTests)
        return try render(stencils: stencils, with: context.dictionary)
    }

    public func renderPlugin(
        context: PluginStencilContext,
        includeTests: Bool
    ) throws -> [String: String] {
        let stencils: [StencilTemplate] = includeTests ? [.plugin, .pluginTests] : [.plugin]
        return try render(stencils: stencils, with: context.dictionary)
    }

    public func renderPluginList(context: PluginListStencilContext) throws -> String {
        try render(.pluginList, with: context.dictionary)
    }

    public func renderWorker(context: WorkerStencilContext) throws -> String {
        try render(.worker, with: context.dictionary)
    }

    internal func render(_ stencil: StencilTemplate, with context: [String: Any]) throws -> String {
        let bundle: Bundle = .moduleRelativeToExecutable ?? .module
        // swiftlint:disable:next force_unwrapping
        let stencilURL: URL = bundle.url(forResource: stencil.filename, withExtension: "stencil")!
        let template: String = try .init(contentsOf: stencilURL)
        let environment: Environment = .init(loader: DictionaryLoader(templates: [stencil.name: template]),
                                             extensions: stencilExtensions(),
                                             trimBehaviour: .smart)
        return try environment.renderTemplate(name: stencil.name, context: context)
    }

    private func render(stencils: [StencilTemplate], with context: [String: Any]) throws -> [String: String] {
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
