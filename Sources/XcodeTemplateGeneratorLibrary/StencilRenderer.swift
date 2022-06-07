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
        try renderNode(stencils: [
            "Analytics": "Analytics",
            "Builder": "Builder\(swiftUI ? "-SwiftUI" : "")",
            "Context": "Context",
            "Flow": "Flow",
            "ViewController": "ViewController\(swiftUI ? "-SwiftUI" : "")",
            "Worker": "Worker"
        ], with: context.dictionary)
    }

    public func renderNodeRoot(
        context: NodeRootContext,
        swiftUI: Bool = false
    ) throws -> [String: String] {
        try renderNode(stencils: [
            "Analytics": "Analytics",
            "Builder": "Builder\(swiftUI ? "-SwiftUI" : "")",
            "Context": "Context",
            "Flow": "Flow",
            "ViewController": "ViewController\(swiftUI ? "-SwiftUI" : "")",
            "Worker": "Worker"
        ], with: context.dictionary)
    }

    public func renderNodeViewInjected(
        context: NodeViewInjectedContext
    ) throws -> [String: String] {
        try renderNode(stencils: [
            "Analytics": "Analytics",
            "Builder": "Builder",
            "Context": "Context",
            "Flow": "Flow",
            "Worker": "Worker"
        ], with: context.dictionary)
    }

    public func renderNodeWithoutViewState(
        context: NodeWithoutViewStateContext,
        swiftUI: Bool = false
    ) throws -> [String: String] {
        try renderNode(stencils: [
            "Analytics": "Analytics",
            "Builder": "Builder\(swiftUI ? "-SwiftUI" : "")",
            "Context": "Context",
            "Flow": "Flow",
            "ViewController": "ViewController\(swiftUI ? "-SwiftUI" : "")",
            "Worker": "Worker"
        ], with: context.dictionary)
    }

    public func renderNodeWithPlugin(
        context: NodeWithPluginContext
    ) throws -> [String: String] {
        var renderedNode = try renderNode(stencils: [
            "Analytics": "Analytics",
            "Builder": "Builder",
            "Context": "Context",
            "Flow": "Flow",
            "ViewController": "ViewController",
            "Worker": "Worker"
        ], with: context.dictionary)
        renderedNode["Plugin"] = try render("Plugin", of: "Plugin", with: context.dictionary)
        return renderedNode
    }

    public func renderPlugin(context: PluginContext) throws -> String {
        try render("Plugin", of: "Plugin", with: context.dictionary)
    }

    public func renderPluginList(context: PluginListContext) throws -> String {
        try render("PluginList", of: "Plugin", with: context.dictionary)
    }

    public func renderPluginMap(context: PluginMapContext) throws -> String {
        try render("PluginMap", of: "Plugin", with: context.dictionary)
    }

    public func renderWorker(context: WorkerContext) throws -> String {
        try render("Worker", of: "Node", with: context.dictionary)
    }

    private func renderNode(stencils: [String: String], with context: [String: Any]) throws -> [String: String] {
        try Dictionary(uniqueKeysWithValues: stencils.map {
            try ($0.0, render($0.1, of: "Node", with: context))
        })
    }

    internal func render(_ stencil: String, of type: String, with context: [String: Any]) throws -> String {
        let bundle: Bundle = .moduleRelativeToExecutable ?? .module
        // swiftlint:disable:next force_unwrapping
        let stencilURL: URL = bundle.resourceURL!
            .appendingPathComponent("Templates")
            .appendingPathComponent(type)
            .appendingPathComponent(stencil)
            .appendingPathExtension("stencil")
        let template: String = try .init(contentsOf: stencilURL)
        let environment: Environment = .init(loader: DictionaryLoader(templates: [stencil: template]))
        return try environment.renderTemplate(name: stencil, context: context)
    }
}
