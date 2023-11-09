//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct NodeTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String
    internal let stencils: [StencilTemplate]
    internal let context: Context
    internal let propertyList: PropertyList

    internal init(for kind: UIFramework.Kind, config: Config) throws {
        let uiFramework: UIFramework = try config.uiFramework(for: kind)
        let node: StencilTemplate.Node = .init(for: .variation(for: uiFramework.kind))
        name = "Node - \(uiFramework.name)"
        stencils = node.stencils
        context = NodeContext(
            fileHeader: config.fileHeader,
            nodeName: config.variable("productName"),
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
            viewControllerType: uiFramework.viewControllerType,
            viewControllableType: config.viewControllableType,
            viewControllableFlowType: config.viewControllableFlowType,
            viewControllerSubscriptionsProperty: config.viewControllerSubscriptionsProperty,
            viewControllerSuperParameters: uiFramework.viewControllerSuperParameters,
            viewControllerProperties: uiFramework.viewControllerProperties,
            viewControllerMethods: uiFramework.viewControllerMethods,
            viewControllableMockContents: uiFramework.viewControllableMockContents,
            viewControllerUpdateComment: config.viewControllerUpdateComment,
            viewStateOperators: config.viewStateOperators,
            viewStateTransform: config.viewStateTransform,
            publisherType: config.publisherType,
            publisherFailureType: config.publisherFailureType,
            contextGenericTypes: config.contextGenericTypes,
            workerGenericTypes: config.workerGenericTypes,
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled
        )
        propertyList = PropertyList(description: "The source files implementing a Node.",
                                    // swiftlint:disable:next force_unwrapping
                                    sortOrder: UIFramework.Kind.allCases.firstIndex(of: kind)! + 1) {
            Option(identifier: "productName",
                   name: "Node name:",
                   description: "The name of the Node")
        }
    }
}
