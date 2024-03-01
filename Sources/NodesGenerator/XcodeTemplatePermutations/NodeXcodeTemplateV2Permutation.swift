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
        stencils = node.stencils(includeState: true, includeTests: config.isTestTemplatesGenerationEnabled)
        // swiftlint:disable:next force_try
        stencilContext = try! NodeStencilContext(
            fileHeader: config.fileHeader,
            nodeName: XcodeTemplateConstants.variable(XcodeTemplateConstants.productName),
            pluginListName: usePluginList ? XcodeTemplateConstants.variable(XcodeTemplateConstants.pluginListName) : "",
            analyticsImports: node.analytics.imports(for: uiFramework, config: config),
            builderImports: node.builder.imports(for: uiFramework, config: config),
            contextImports: node.context.imports(for: uiFramework, config: config),
            flowImports: node.flow.imports(for: uiFramework, config: config),
            stateImports: node.state.imports(for: uiFramework, config: config),
            viewControllerImports: node.viewController.imports(for: uiFramework, config: config),
            viewStateImports: node.viewState.imports(for: uiFramework, config: config),
            analyticsTestsImports: StencilTemplate.analyticsTests.imports(for: uiFramework, config: config),
            contextTestsImports: StencilTemplate.contextTests.imports(for: uiFramework, config: config),
            flowTestsImports: StencilTemplate.flowTests.imports(for: uiFramework, config: config),
            viewControllerTestsImports: node.viewControllerTests.imports(for: uiFramework, config: config),
            viewStateFactoryTestsImports: node.viewStateFactoryTests.imports(for: uiFramework, config: config),
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
