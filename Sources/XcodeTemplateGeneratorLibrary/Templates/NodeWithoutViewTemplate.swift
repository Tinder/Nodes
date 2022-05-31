//
//  NodeWithoutViewTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

internal struct NodeWithoutViewTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String = "Node (without view)"
    internal let type: String = "Node"
    internal let stencils: [String] = ["Analytics", "Builder", "Context", "Flow", "Worker"]
    internal let context: Context

    internal let propertyList: PropertyList =
        .init(description: "The source files implementing a Node.",
              sortOrder: 3) {
            Option(identifier: "productName",
                   name: "Node name:",
                   description: "The name of the Node")
        }

    internal init(config: Config) {
        context = NodeWithoutViewContext(
            fileHeader: config.fileHeader,
            nodeName: config.variable("productName"),
            workerName: config.variable("productName"),
            publicNode: false,
            builderImports: config.imports(for: .diGraph),
            contextImports: config.imports(for: .nodes),
            flowImports: config.imports(for: .nodes),
            workerImports: config.imports(for: .nodes),
            dependencies: config.dependencies,
            flowProperties: config.flowProperties,
            viewControllableType: config.viewControllableType,
            viewControllableFlowType: config.viewControllableFlowType,
            cancellableType: config.cancellableType
        )
    }
}
