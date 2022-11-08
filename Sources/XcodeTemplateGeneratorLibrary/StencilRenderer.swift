//
//  StencilRenderer.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

import Foundation
import Stencil

public final class StencilRenderer {

    public init() {}

    public func renderNode(
        context: NodeContext,
        swiftUI: Bool = false
    ) throws -> [String: String] {
        try renderNode(stencils: NodeStencils.get(for: .viewOwned(swiftUI: swiftUI)),
                       with: context.dictionary)
    }

    public func renderNodeRoot(
        context: NodeRootContext,
        swiftUI: Bool = false
    ) throws -> [String: String] {
        try renderNode(stencils: NodeStencils.get(for: .viewOwned(swiftUI: swiftUI)),
                       with: context.dictionary)
    }

    public func renderNodeViewInjected(
        context: NodeViewInjectedContext
    ) throws -> [String: String] {
        try renderNode(stencils: NodeStencils.get(for: .viewInjected),
                       with: context.dictionary)
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

    private func renderNode(
        stencils: [StencilTemplate],
        with context: [String: Any]
    ) throws -> [String: String] {
        try Dictionary(uniqueKeysWithValues: stencils.map {
            try ($0.outputFilename, render($0, with: context))
        })
    }

    internal func render(_ stencil: StencilTemplate, with context: [String: Any]) throws -> String {
        let filename: String = stencil.filename
        let bundle: Bundle = .moduleRelativeToExecutable ?? .module
        // swiftlint:disable:next force_unwrapping
        let stencilURL: URL = bundle.resourceURL!
            .appendingPathComponent("Templates")
            .appendingPathComponent(filename)
            .appendingPathExtension("stencil")
        let template: String = try .init(contentsOf: stencilURL)
        let environment: Environment = .init(loader: DictionaryLoader(templates: [filename: template]))
        return try environment.renderTemplate(name: filename, context: context)
    }
}
