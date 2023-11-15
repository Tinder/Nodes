//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Foundation
import Stencil

public final class StencilRenderer {

    public init() {}

    public func renderNodeStencil(
        context: NodeStencilContext,
        kind: UIFramework.Kind,
        includeTests: Bool
    ) throws -> [String: String] {
        let node: StencilTemplate.Node = .init(for: .variation(for: kind))
        return try renderNodeStencil(templates: node.stencilTemplates(includeTests: includeTests),
                                     with: context.dictionary)
    }

    public func renderNodeRootStencil(
        context: NodeRootStencilContext
    ) throws -> [String: String] {
        let node: StencilTemplate.Node = .init(for: .variation(for: .uiKit))
        return try renderNodeStencil(templates: node.stencilTemplates(includeTests: false),
                                     with: context.dictionary)
    }

    public func renderNodeViewInjectedStencil(
        context: NodeViewInjectedStencilContext,
        includeTests: Bool
    ) throws -> [String: String] {
        let nodeViewInjected: StencilTemplate.NodeViewInjected = .init()
        return try renderNodeStencil(templates: nodeViewInjected.stencilTemplates(includeTests: includeTests),
                                     with: context.dictionary)
    }

    public func renderPluginStencil(context: PluginStencilContext) throws -> String {
        try renderStencil(.plugin, with: context.dictionary)
    }

    public func renderPluginListStencil(context: PluginListStencilContext) throws -> String {
        try renderStencil(.pluginList, with: context.dictionary)
    }

    public func renderWorkerStencil(context: WorkerStencilContext) throws -> String {
        try renderStencil(.worker, with: context.dictionary)
    }

    internal func renderStencil(_ template: StencilTemplate, with context: [String: Any]) throws -> String {
        let bundle: Bundle = .moduleRelativeToExecutable ?? .module
        // swiftlint:disable:next force_unwrapping
        let url: URL = bundle.resourceURL!
            .appendingPathComponent("StencilTemplates")
            .appendingPathComponent(template.filename)
            .appendingPathExtension("stencil")
        let contents: String = try .init(contentsOf: url)
        let environment: Environment = .init(loader: DictionaryLoader(templates: [template.name: contents]),
                                             trimBehaviour: .smart)
        return try environment.renderTemplate(name: template.name, context: context)
    }

    private func renderNodeStencil(
        templates: [StencilTemplate],
        with context: [String: Any]
    ) throws -> [String: String] {
        try Dictionary(uniqueKeysWithValues: templates.map { template in
            (template.name, try renderStencil(template, with: context))
        })
    }
}
