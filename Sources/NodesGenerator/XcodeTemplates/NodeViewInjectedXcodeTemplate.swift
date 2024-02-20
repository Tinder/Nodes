//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct NodeViewInjectedXcodeTemplate: XcodeTemplate {

    internal let name: String = "Node (view injected)"
    internal let stencils: [StencilTemplate]
    internal let stencilContext: StencilContext

    internal let propertyList: PropertyList =
        .init(description: "The source files implementing a Node.",
              sortOrder: 5) {
            Option(identifier: XcodeTemplateConstants.productName,
                   name: "Node name:",
                   description: "The name of the Node")
        }

    internal init(config: Config) {
        let node: StencilTemplate.NodeViewInjected = .init()
        stencils = node.stencils(includeTests: config.isTestTemplatesGenerationEnabled)
        // swiftlint:disable:next force_try
        stencilContext = try! NodeViewInjectedStencilContext(
            fileHeader: config.fileHeader,
            nodeName: XcodeTemplateConstants.variable(XcodeTemplateConstants.productName),
            analyticsImports: node.analytics.imports(config: config),
            builderImports: node.builder.imports(config: config),
            contextImports: node.context.imports(config: config),
            flowImports: node.flow.imports(config: config),
            stateImports: node.state.imports(config: config),
            analyticsTestsImports: node.analyticsTests.imports(config: config),
            contextTestsImports: node.contextTests.imports(config: config),
            flowTestsImports: node.flowTests.imports(config: config),
            dependencies: config.dependencies,
            analyticsProperties: config.analyticsProperties,
            flowProperties: config.flowProperties,
            viewControllableFlowType: config.viewControllableFlowType,
            viewControllableType: config.viewControllableType,
            viewControllableMockContents: config.viewControllableMockContents,
            contextGenericTypes: config.contextGenericTypes,
            workerGenericTypes: config.workerGenericTypes,
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled,
            isNimbleEnabled: config.isNimbleEnabled
        )
    }
}
