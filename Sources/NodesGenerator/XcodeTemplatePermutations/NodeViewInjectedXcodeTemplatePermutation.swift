//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

internal struct NodeViewInjectedXcodeTemplatePermutation: XcodeTemplatePermutation {

    internal let name: String
    internal let stencils: [StencilTemplate]
    internal let stencilContext: StencilContext

    internal init(name: String, config: Config) {
        self.name = name
        let node: StencilTemplate.NodeViewInjected = .init()
        stencils = node.stencils(includePlugin: true, includeTests: config.isTestTemplatesGenerationEnabled)
        let productName: String = XcodeTemplateConstants.variable(XcodeTemplateConstants.productName)
        // swiftlint:disable:next force_try
        stencilContext = try! NodeViewInjectedStencilContext(
            fileHeader: XcodeTemplateConstants.fileHeader,
            nodeName: productName,
            pluginName: productName,
            analyticsImports: node.analytics.imports(with: config),
            analyticsTestsImports: node.analyticsTests.imports(with: config),
            builderImports: node.builder.imports(with: config),
            builderTestsImports: node.builderTests.imports(with: config),
            contextImports: node.context.imports(with: config),
            contextTestsImports: node.contextTests.imports(with: config),
            flowImports: node.flow.imports(with: config),
            flowTestsImports: node.flowTests.imports(with: config),
            pluginImports: node.plugin.imports(with: config),
            pluginTestsImports: node.pluginTests.imports(with: config),
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
