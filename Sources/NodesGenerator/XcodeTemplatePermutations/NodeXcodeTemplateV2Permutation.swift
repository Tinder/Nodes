//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

internal struct NodeXcodeTemplateV2Permutation: XcodeTemplatePermutation {

    internal let name: String
    internal let stencils: [StencilTemplate]
    internal let stencilContext: StencilContext

    internal init(usePluginList: Bool, for uiFramework: UIFramework, config: Config) {
        let node: StencilTemplate.Node = StencilTemplate.Node(for: .variation(for: uiFramework.kind))
        name = "\(usePluginList ? XcodeTemplateConstants.usePluginList : "")\(uiFramework.name)"
        stencils = node.stencils(includeTests: config.isTestTemplatesGenerationEnabled)
        let productName: String = XcodeTemplateConstants.variable(XcodeTemplateConstants.productName)
        // swiftlint:disable:next force_try
        stencilContext = try! NodeStencilContext(
            fileHeader: config.fileHeader,
            nodeName: productName,
            pluginName: productName,
            pluginListName: usePluginList ? XcodeTemplateConstants.variable(XcodeTemplateConstants.pluginListName) : "",
            analyticsImports: node.analytics.imports(with: config, including: uiFramework),
            builderImports: node.builder.imports(with: config, including: uiFramework),
            contextImports: node.context.imports(with: config, including: uiFramework),
            flowImports: node.flow.imports(with: config, including: uiFramework),
            stateImports: node.state.imports(with: config, including: uiFramework),
            viewControllerImports: node.viewController.imports(with: config, including: uiFramework),
            viewStateImports: node.viewState.imports(with: config, including: uiFramework),
            analyticsTestsImports: node.analyticsTests.imports(with: config, including: uiFramework),
            contextTestsImports: node.contextTests.imports(with: config, including: uiFramework),
            flowTestsImports: node.flowTests.imports(with: config, including: uiFramework),
            viewControllerTestsImports: node.viewControllerTests.imports(with: config, including: uiFramework),
            viewStateFactoryTestsImports: node.viewStateFactoryTests.imports(with: config, including: uiFramework),
            dependencies: config.dependencies,
            analyticsProperties: config.analyticsProperties,
            flowProperties: config.flowProperties,
            viewControllableFlowType: config.viewControllableFlowType,
            viewControllableType: config.viewControllableType,
            viewControllableMockContents: config.viewControllableMockContents,
            viewControllerType: uiFramework.viewControllerType,
            viewControllerSuperParameters: uiFramework.viewControllerSuperParameters,
            viewControllerProperties: uiFramework.viewControllerProperties,
            viewControllerMethods: uiFramework.viewControllerMethods,
            viewControllerSubscriptionsProperty: config.viewControllerSubscriptionsProperty,
            viewControllerUpdateComment: config.viewControllerUpdateComment,
            viewStateEmptyFactory: config.viewStateEmptyFactory,
            viewStateOperators: config.viewStateOperators,
            viewStatePropertyComment: config.viewStatePropertyComment,
            viewStatePropertyName: config.viewStatePropertyName,
            viewStateTransform: config.viewStateTransform,
            publisherType: config.publisherType,
            publisherFailureType: config.publisherFailureType,
            contextGenericTypes: config.contextGenericTypes,
            workerGenericTypes: config.workerGenericTypes,
            isPreviewProviderEnabled: config.isPreviewProviderEnabled,
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled,
            isNimbleEnabled: config.isNimbleEnabled
        )
    }
}
