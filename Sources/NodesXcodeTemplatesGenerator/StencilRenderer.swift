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
        includeTests: Bool
    ) throws -> [String: String] {
        let node: StencilTemplate.Node = .init(for: .variation(for: kind))
        return try renderNode(templates: node.stencilTemplates(includeTests: includeTests), with: context.dictionary)
    }

    public func renderNodeRoot(
        context: NodeRootStencilContext
    ) throws -> [String: String] {
        let node: StencilTemplate.Node = .init(for: .variation(for: .uiKit))
        return try renderNode(templates: node.stencilTemplates(includeTests: false), with: context.dictionary)
    }

    public func renderNodeViewInjected(
        context: NodeViewInjectedStencilContext,
        includeTests: Bool
    ) throws -> [String: String] {
        let nodeViewInjected: StencilTemplate.NodeViewInjected = .init()
        return try renderNode(templates: nodeViewInjected.stencilTemplates(includeTests: includeTests),
                              with: context.dictionary)
    }

    public func renderPlugin(context: PluginStencilContext) throws -> String {
        try render(.plugin, with: context.dictionary)
    }

    public func renderPluginList(context: PluginListStencilContext) throws -> String {
        try render(.pluginList, with: context.dictionary)
    }

    public func renderWorker(context: WorkerStencilContext) throws -> String {
        try render(.worker, with: context.dictionary)
    }

    internal func render(_ template: StencilTemplate, with context: [String: Any]) throws -> String {
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

    private func renderNode(templates: [StencilTemplate], with context: [String: Any]) throws -> [String: String] {
        try Dictionary(uniqueKeysWithValues: templates.map { template in
            (template.name, try render(template, with: context))
        })
    }
}
