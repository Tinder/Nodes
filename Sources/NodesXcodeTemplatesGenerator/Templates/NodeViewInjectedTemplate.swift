//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct NodeViewInjectedTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String = "Node (view injected)"
    internal let stencils: [StencilTemplate]
    internal let context: Context

    internal let propertyList: PropertyList =
        .init(description: "The source files implementing a Node.",
              sortOrder: 5) {
            Option(identifier: "productName",
                   name: "Node name:",
                   description: "The name of the Node")
        }

    internal init(config: Config) {
        let node: StencilTemplate.NodeViewInjected = .init()
        stencils = node.stencils
        context = NodeViewInjectedContext(
            fileHeader: config.fileHeader,
            nodeName: config.variable("productName"),
            analyticsImports: node.analytics.imports(config: config),
            builderImports: node.builder.imports(config: config),
            contextImports: node.context.imports(config: config),
            flowImports: node.flow.imports(config: config),
            stateImports: node.state.imports(config: config),
            dependencies: config.dependencies,
            analyticsProperties: config.analyticsProperties,
            flowProperties: config.flowProperties,
            viewControllableType: config.viewControllableType,
            viewControllableFlowType: config.viewControllableFlowType,
            cancellableType: config.cancellableType
        )
    }
}
