//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

internal struct NodeViewInjectedXcodeTemplatePermutation: XcodeTemplatePermutation {

    internal let name: String
    internal let stencils: [StencilTemplate]
    internal let stencilContext: StencilContext

    internal init(name: String, config: Config) {
        self.name = name
        let node: StencilTemplate.NodeViewInjected = .init()
        stencils = node.stencils(includePlugin: true, includeTests: config.isTestTemplatesGenerationEnabled)
        // swiftlint:disable:next force_try
        stencilContext = try! NodeViewInjectedStencilContext(
            fileHeader: XcodeTemplateConstants.fileHeader,
            nodeName: XcodeTemplateConstants.variable(XcodeTemplateConstants.productName),
            analyticsImports: node.analytics.imports(with: config),
            analyticsTestsImports: node.analyticsTests.imports(with: config),
            builderImports: node.builder.imports(with: config),
            builderTestsImports: node.builderTests.imports(with: config),
            contextImports: node.context.imports(with: config),
            contextTestsImports: node.contextTests.imports(with: config),
            flowImports: node.flow.imports(with: config),
            flowTestsImports: node.flowTests.imports(with: config),
            pluginImports: node.plugin.imports(with: config),
            stateImports: node.state.imports(with: config),
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
