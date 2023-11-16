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
        let stencils: [StencilTemplate] = node.stencils(includeTests: includeTests)
        return try renderNode(stencils: stencils, with: context.dictionary)
    }

    public func renderNodeViewInjected(
        context: NodeViewInjectedStencilContext,
        includeTests: Bool
    ) throws -> [String: String] {
        let nodeViewInjected: StencilTemplate.NodeViewInjected = .init()
        let stencils: [StencilTemplate] = nodeViewInjected.stencils(includeTests: includeTests)
        return try renderNode(stencils: stencils, with: context.dictionary)
    }

    public func renderNodePreset(
        context: NodePresetStencilContext
    ) throws -> [String: String] {
        let stencils: [StencilTemplate]
        if context.preset.ownsView {
            stencils = StencilTemplate.Node(for: .variation(for: .uiKit)).stencils(includeTests: false)
        } else {
            stencils = StencilTemplate.NodeViewInjected().stencils(includeTests: false)
        }
        return try renderNode(stencils: stencils, with: context.dictionary)
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

    internal func render(_ stencil: StencilTemplate, with context: [String: Any]) throws -> String {
        let bundle: Bundle = .moduleRelativeToExecutable ?? .module
        // swiftlint:disable:next force_unwrapping
        let stencilURL: URL = bundle.resourceURL!
            .appendingPathComponent("Stencils")
            .appendingPathComponent(stencil.filename)
            .appendingPathExtension("stencil")
        let template: String = try .init(contentsOf: stencilURL)
        let environment: Environment = .init(loader: DictionaryLoader(templates: [stencil.name: template]),
                                             trimBehaviour: .smart)
        return try environment.renderTemplate(name: stencil.name, context: context)
    }

    private func renderNode(stencils: [StencilTemplate], with context: [String: Any]) throws -> [String: String] {
        try Dictionary(uniqueKeysWithValues: stencils.map { stencil in
            try (stencil.name, render(stencil, with: context))
        })
    }
}
