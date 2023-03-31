//
//  StencilRenderer.swift
//  NodesXcodeTemplatesGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

import Foundation
import Stencil

public final class StencilRenderer {

    public init() {}

    public func renderNode(
        context: NodeContext,
        kind: UIFramework.Kind
    ) throws -> [String: String] {
        try renderNode(stencils: StencilTemplate.Node(for: .variation(for: kind)).stencils, with: context.dictionary)
    }

    public func renderNodeRoot(
        context: NodeRootContext,
        kind: UIFramework.Kind
    ) throws -> [String: String] {
        try renderNode(stencils: StencilTemplate.Node(for: .variation(for: kind)).stencils, with: context.dictionary)
    }

    public func renderNodeViewInjected(
        context: NodeViewInjectedContext
    ) throws -> [String: String] {
        try renderNode(stencils: StencilTemplate.NodeViewInjected().stencils, with: context.dictionary)
    }

    public func renderPlugin(context: PluginContext) throws -> String {
        try render(.plugin, with: context.dictionary)
    }

    public func renderPluginList(context: PluginListContext) throws -> String {
        try render(.pluginList, with: context.dictionary)
    }

    public func renderWorker(context: WorkerContext) throws -> String {
        try render(.worker, with: context.dictionary)
    }

    private func renderNode(stencils: [StencilTemplate], with context: [String: Any]) throws -> [String: String] {
        try Dictionary(uniqueKeysWithValues: stencils.map { stencil in
            try (stencil.name, render(stencil, with: context))
        })
    }

    internal func render(_ stencil: StencilTemplate, with context: [String: Any]) throws -> String {
        let bundle: Bundle = .moduleRelativeToExecutable ?? .module
        // swiftlint:disable:next force_unwrapping
        let stencilURL: URL = bundle.resourceURL!
            .appendingPathComponent("Templates")
            .appendingPathComponent(stencil.filename)
            .appendingPathExtension("stencil")
        let template: String = try .init(contentsOf: stencilURL)
        let environment: Environment = .init(loader: DictionaryLoader(templates: [stencil.name: template]))
        return try environment.renderTemplate(name: stencil.name, context: context)
    }
}
