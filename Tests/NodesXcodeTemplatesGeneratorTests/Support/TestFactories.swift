//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import NodesXcodeTemplatesGenerator

protocol TestFactories {}

extension TestFactories {

    private typealias Variable = Config.Variable

    internal func givenConfig() -> Config {
        var config: Config = .init()
        config.uiFrameworks = [
            UIFramework(framework: .appKit),
            UIFramework(framework: .uiKit),
            UIFramework(framework: .swiftUI),
            UIFramework(framework: .custom(name: "<uiFrameworkName>",
                                           import: "<uiFrameworkImport>",
                                           viewControllerType: "<viewControllerType>",
                                           viewControllerSuperParameters: "<viewControllerSuperParameters>"))
        ].map { uiFramework in
            var uiFramework: UIFramework = uiFramework
            uiFramework.viewControllerProperties = "<viewControllerProperties>"
            uiFramework.viewControllerMethods = "<viewControllerMethods>"
            return uiFramework
        }
        config.fileHeader = "<fileHeader>"
        config.baseImports = ["<baseImport>"]
        config.baseTestImports = ["<baseTestImport>"]
        config.reactiveImports = ["<reactiveImport>"]
        config.dependencyInjectionImports = ["<dependencyInjectionImport>"]
        config.dependencies = [Variable(name: "<dependenciesName>", type: "<dependenciesType>")]
        config.analyticsProperties = [Variable(name: "<analyticsPropertiesName>", type: "<analyticsPropertiesType>")]
        config.flowProperties = [Variable(name: "<flowPropertiesName>", type: "<flowPropertiesType>")]
        config.viewControllableFlowType = "<viewControllableFlowType>"
        config.viewControllableType = "<viewControllableType>"
        config.viewControllableMockContents = "<viewControllableMockContents>"
        config.viewControllerSubscriptionsProperty = "<viewControllerSubscriptionsProperty>"
        config.viewControllerUpdateComment = "<viewControllerUpdateComment>"
        config.viewStateEmptyFactory = "<viewStateEmptyFactory>"
        config.viewStateOperators = "<viewStateOperators>"
        config.viewStatePropertyComment = "<viewStatePropertyComment>"
        config.viewStatePropertyName = "<viewStatePropertyName>"
        config.viewStateTransform = "<viewStateTransform>"
        config.publisherType = "<publisherType>"
        config.publisherFailureType = "<publisherFailureType>"
        config.contextGenericTypes = ["<contextGenericType>"]
        config.workerGenericTypes = ["<workerGenericType>"]
        config.isViewInjectedTemplateEnabled = true
        config.isPreviewProviderEnabled = false
        config.isTestTemplatesGenerationEnabled = false
        config.isPeripheryCommentEnabled = false
        return config
    }

    internal func givenNodeStencilContext(
        nodeName: String = "<nodeName>",
        mockCount: Int = 1
    ) throws -> NodeStencilContext {
        try NodeStencilContext(
            fileHeader: "<fileHeader>",
            nodeName: nodeName,
            analyticsImports: .mock(with: "analyticsImport", count: mockCount),
            builderImports: .mock(with: "builderImport", count: mockCount),
            contextImports: .mock(with: "contextImport", count: mockCount),
            flowImports: .mock(with: "flowImport", count: mockCount),
            stateImports: .mock(with: "stateImport", count: mockCount),
            viewControllerImports: .mock(with: "viewControllerImport", count: mockCount),
            viewStateImports: .mock(with: "viewStateImport", count: mockCount),
            analyticsTestsImports: .mock(with: "analyticsTestsImport", count: mockCount),
            contextTestsImports: .mock(with: "contextTestsImport", count: mockCount),
            flowTestsImports: .mock(with: "flowTestsImport", count: mockCount),
            viewControllerTestsImports: .mock(with: "viewControllerTestsImport", count: mockCount),
            viewStateFactoryTestsImports: .mock(with: "viewStateFactoryTestsImport", count: mockCount),
            dependencies: .mock(with: "dependency", count: mockCount),
            analyticsProperties: .mock(with: "analyticsProperty", count: mockCount),
            flowProperties: .mock(with: "flowProperty", count: mockCount),
            viewControllableFlowType: "<viewControllableFlowType>",
            viewControllableType: "<viewControllableType>",
            viewControllableMockContents: mockCount > 0 ? "<viewControllableMockContents>" : "",
            viewControllerType: "<viewControllerType>",
            viewControllerSuperParameters: mockCount > 0 ? "<viewControllerSuperParameters>" : "",
            viewControllerProperties: mockCount > 0 ? "<viewControllerProperties>" : "",
            viewControllerMethods: mockCount > 0 ? "<viewControllerMethods>" : "",
            viewControllerSubscriptionsProperty: "<viewControllerSubscriptionsProperty>",
            viewControllerUpdateComment: mockCount > 0 ? "<viewControllerUpdateComment>" : "",
            viewStateEmptyFactory: "<viewStateEmptyFactory>",
            viewStateOperators: mockCount > 0 ? "<viewStateOperators>" : "",
            viewStatePropertyComment: "<viewStatePropertyComment>",
            viewStatePropertyName: "<viewStatePropertyName>",
            viewStateTransform: "<viewStateTransform>",
            publisherType: "<publisherType>",
            publisherFailureType: mockCount > 0 ? "<publisherFailureType>" : "",
            contextGenericTypes: .mock(with: "contextGenericType", count: mockCount),
            workerGenericTypes: .mock(with: "workerGenericType", count: mockCount),
            isPreviewProviderEnabled: mockCount > 0,
            isPeripheryCommentEnabled: mockCount > 0,
            isNimbleEnabled: mockCount > 0
        )
    }

    internal func givenNodeViewInjectedStencilContext(
        nodeName: String = "<nodeName>",
        mockCount: Int = 1
    ) throws -> NodeViewInjectedStencilContext {
        try NodeViewInjectedStencilContext(
            fileHeader: "<fileHeader>",
            nodeName: nodeName,
            analyticsImports: .mock(with: "analyticsImport", count: mockCount),
            builderImports: .mock(with: "builderImport", count: mockCount),
            contextImports: .mock(with: "contextImport", count: mockCount),
            flowImports: .mock(with: "flowImport", count: mockCount),
            stateImports: .mock(with: "stateImport", count: mockCount),
            analyticsTestsImports: .mock(with: "analyticsTestsImport", count: mockCount),
            contextTestsImports: .mock(with: "contextTestsImport", count: mockCount),
            flowTestsImports: .mock(with: "flowTestsImport", count: mockCount),
            dependencies: .mock(with: "dependency", count: mockCount),
            analyticsProperties: .mock(with: "analyticsProperty", count: mockCount),
            flowProperties: .mock(with: "flowProperty", count: mockCount),
            viewControllableFlowType: "<viewControllableFlowType>",
            viewControllableType: "<viewControllableType>",
            viewControllableMockContents: mockCount > 0 ? "<viewControllableMockContents>" : "",
            contextGenericTypes: .mock(with: "contextGenericType", count: mockCount),
            workerGenericTypes: .mock(with: "workerGenericType", count: mockCount),
            isPeripheryCommentEnabled: mockCount > 0,
            isNimbleEnabled: mockCount > 0
        )
    }

    internal func givenNodePresetStencilContext(
        preset: NodePresetStencilContext.Preset,
        mockCount: Int = 1
    ) -> NodePresetStencilContext {
        NodePresetStencilContext(
            preset: preset,
            fileHeader: "<fileHeader>",
            analyticsImports: .mock(with: "analyticsImport", count: mockCount),
            builderImports: .mock(with: "builderImport", count: mockCount),
            contextImports: .mock(with: "contextImport", count: mockCount),
            flowImports: .mock(with: "flowImport", count: mockCount),
            stateImports: .mock(with: "stateImport", count: mockCount),
            viewControllerImports: .mock(with: "viewControllerImport", count: mockCount),
            viewStateImports: .mock(with: "viewStateImport", count: mockCount),
            analyticsTestsImports: .mock(with: "analyticsTestsImport", count: mockCount),
            contextTestsImports: .mock(with: "contextTestsImport", count: mockCount),
            flowTestsImports: .mock(with: "flowTestsImport", count: mockCount),
            viewControllerTestsImports: .mock(with: "viewControllerTestsImport", count: mockCount),
            viewStateFactoryTestsImports: .mock(with: "viewStateFactoryTestsImport", count: mockCount),
            dependencies: .mock(with: "dependency", count: mockCount),
            analyticsProperties: .mock(with: "analyticsProperty", count: mockCount),
            flowProperties: .mock(with: "flowProperty", count: mockCount),
            viewControllableFlowType: "<viewControllableFlowType>",
            viewControllableType: "<viewControllableType>",
            viewControllableMockContents: mockCount > 0 ? "<viewControllableMockContents>" : "",
            viewControllerType: "<viewControllerType>",
            viewControllerSuperParameters: mockCount > 0 ? "<viewControllerSuperParameters>" : "",
            viewControllerProperties: mockCount > 0 ? "<viewControllerProperties>" : "",
            viewControllerMethods: mockCount > 0 ? "<viewControllerMethods>" : "",
            viewControllerSubscriptionsProperty: "<viewControllerSubscriptionsProperty>",
            viewControllerUpdateComment: mockCount > 0 ? "<viewControllerUpdateComment>" : "",
            viewStateEmptyFactory: "<viewStateEmptyFactory>",
            viewStateOperators: mockCount > 0 ? "<viewStateOperators>" : "",
            viewStatePropertyComment: "<viewStatePropertyComment>",
            viewStatePropertyName: "<viewStatePropertyName>",
            viewStateTransform: "<viewStateTransform>",
            publisherType: "<publisherType>",
            publisherFailureType: mockCount > 0 ? "<publisherFailureType>" : "",
            contextGenericTypes: .mock(with: "contextGenericType", count: mockCount),
            workerGenericTypes: .mock(with: "workerGenericType", count: mockCount),
            isPreviewProviderEnabled: mockCount > 0,
            isPeripheryCommentEnabled: mockCount > 0,
            isNimbleEnabled: mockCount > 0
        )
    }

    internal func givenPluginStencilContext(mockCount: Int = 1) -> PluginStencilContext {
        PluginStencilContext(
            fileHeader: "<fileHeader>",
            pluginName: "<pluginName>",
            returnType: "<returnType>",
            pluginImports: .mock(with: "pluginImport", count: mockCount),
            pluginTestsImports: .mock(with: "pluginTestsImport", count: mockCount),
            isPeripheryCommentEnabled: mockCount > 0,
            isNimbleEnabled: mockCount > 0
        )
    }

    internal func givenPluginStencilContextWithoutReturnType(mockCount: Int = 1) -> PluginStencilContext {
        PluginStencilContext(
            fileHeader: "<fileHeader>",
            pluginName: "<pluginName>",
            pluginImports: .mock(with: "pluginImport", count: mockCount),
            pluginTestsImports: .mock(with: "pluginTestsImport", count: mockCount),
            isPeripheryCommentEnabled: mockCount > 0
        )
    }

    internal func givenPluginListStencilContext(mockCount: Int = 1) -> PluginListStencilContext {
        PluginListStencilContext(
            fileHeader: "<fileHeader>",
            pluginListName: "<pluginListName>",
            pluginListImports: .mock(with: "pluginListImport", count: mockCount),
            viewControllableFlowType: "<viewControllableFlowType>",
            isPeripheryCommentEnabled: mockCount > 0
        )
    }

    internal func givenWorkerStencilContext(mockCount: Int = 1) -> WorkerStencilContext {
        WorkerStencilContext(
            fileHeader: "<fileHeader>",
            workerName: "<workerName>",
            workerImports: .mock(with: "workerImport", count: mockCount),
            workerGenericTypes: .mock(with: "workerGenericType", count: mockCount),
            isPeripheryCommentEnabled: mockCount > 0
        )
    }
}
