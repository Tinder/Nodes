//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

internal struct NodeXcodeTemplatePermutation: XcodeTemplatePermutation {

    internal let name: String
    internal let stencils: [StencilTemplate]
    internal let stencilContext: StencilContext

    internal init(for uiFramework: UIFramework, createdForPluginList: Bool, config: Config) {
        self.name = "\(uiFramework.name)\(createdForPluginList ? XcodeTemplateConstants.createdForPluginList : "")"
        let node: StencilTemplate.Node = StencilTemplate.Node(.variation(for: uiFramework.kind))
        stencils = node.stencils(includePlugin: true, includeTests: config.isTestTemplatesGenerationEnabled)
        let productName: String = XcodeTemplateConstants.variable(XcodeTemplateConstants.productName)
        let pluginListName: String = XcodeTemplateConstants.variable(XcodeTemplateConstants.pluginListName)
        // swiftlint:disable:next force_try
        stencilContext = try! NodeStencilContext(
            fileHeader: XcodeTemplateConstants.fileHeader,
            nodeName: productName,
            pluginName: productName,
            pluginListName: createdForPluginList ? pluginListName : "",
            analyticsImports: node.analytics.imports(with: config, including: uiFramework),
            analyticsTestsImports: node.analyticsTests.imports(with: config, including: uiFramework),
            builderImports: node.builder.imports(with: config, including: uiFramework),
            builderTestsImports: node.builderTests.imports(with: config, including: uiFramework),
            contextImports: node.context.imports(with: config, including: uiFramework),
            contextTestsImports: node.contextTests.imports(with: config, including: uiFramework),
            flowImports: node.flow.imports(with: config, including: uiFramework),
            flowTestsImports: node.flowTests.imports(with: config, including: uiFramework),
            pluginImports: node.plugin.imports(with: config, including: uiFramework),
            pluginTestsImports: node.pluginTests.imports(with: config, including: uiFramework),
            stateImports: node.state.imports(with: config, including: uiFramework),
            viewControllerImports: node.viewController.imports(with: config, including: uiFramework),
            viewControllerTestsImports: node.viewControllerTests.imports(with: config, including: uiFramework),
            viewStateImports: node.viewState.imports(with: config, including: uiFramework),
            viewStateFactoryTestsImports: node.viewStateFactoryTests.imports(with: config, including: uiFramework),
            dependencies: config.dependencies,
            analyticsProperties: config.analyticsProperties,
            flowProperties: config.flowProperties,
            viewControllableFlowType: config.viewControllableFlowType,
            viewControllableType: config.viewControllableType,
            viewControllableMockContents: config.viewControllableMockContents,
            viewControllerType: uiFramework.viewControllerType,
            viewControllerSuperParameters: uiFramework.viewControllerSuperParameters,
            viewControllerMethods: uiFramework.viewControllerMethods,
            viewControllerStaticContent: config.viewControllerStaticContent,
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
