//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct NodeXcodeTemplate: XcodeTemplate {

    internal let name: String
    internal let stencils: [StencilTemplate]
    internal let stencilContext: StencilContext
    internal let propertyList: PropertyList

    internal init(for kind: UIFramework.Kind, config: Config) throws {
        let uiFramework: UIFramework = try config.uiFramework(for: kind)
        let node: StencilTemplate.Node = .init(for: .variation(for: uiFramework.kind))
        name = "Node - \(uiFramework.name)"
        stencils = node.stencils(includeTests: config.isTestTemplatesGenerationEnabled)
        // swiftlint:disable:next force_try
        stencilContext = try! NodeStencilContext(
            fileHeader: config.fileHeader,
            nodeName: Self.variable(Self.productName),
            analyticsImports: node.analytics.imports(for: uiFramework, config: config),
            builderImports: node.builder.imports(for: uiFramework, config: config),
            contextImports: node.context.imports(for: uiFramework, config: config),
            flowImports: node.flow.imports(for: uiFramework, config: config),
            stateImports: node.state.imports(for: uiFramework, config: config),
            viewControllerImports: node.viewController.imports(for: uiFramework, config: config),
            viewStateImports: node.viewState.imports(for: uiFramework, config: config),
            testImports: config.baseTestImports,
            dependencies: config.dependencies,
            analyticsProperties: config.analyticsProperties,
            flowProperties: config.flowProperties,
            viewControllableType: config.viewControllableType,
            viewControllableFlowType: config.viewControllableFlowType,
            viewControllerType: uiFramework.viewControllerType,
            viewControllerSuperParameters: uiFramework.viewControllerSuperParameters,
            viewControllerProperties: uiFramework.viewControllerProperties,
            viewControllerMethods: uiFramework.viewControllerMethods,
            viewControllableMockContents: uiFramework.viewControllableMockContents,
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
        propertyList = PropertyList(description: "The source files implementing a Node.",
                                    // swiftlint:disable:next force_unwrapping
                                    sortOrder: UIFramework.Kind.allCases.firstIndex(of: kind)! + 1) {
            Option(identifier: Self.productName,
                   name: "Node name:",
                   description: "The name of the Node")
        }
    }
}
