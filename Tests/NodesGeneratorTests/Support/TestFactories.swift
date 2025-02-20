//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import NodesGenerator

protocol TestFactories {}

extension TestFactories {

    private typealias Variable = Config.Variable

    internal func givenConfig() -> Config {
        var config: Config = .init()
        config.uiFrameworks = [
            UIFramework(framework: .appKit),
            UIFramework(framework: .appKitSwiftUI),
            UIFramework(framework: .uiKit),
            UIFramework(framework: .uiKitSwiftUI),
            UIFramework(framework: .custom(name: "Custom",
                                           import: "<uiFrameworkImport>",
                                           viewControllerType: "<viewControllerType>",
                                           viewControllerSuperParameters: "<viewControllerSuperParameters>",
                                           viewControllerMethods: "<viewControllerMethods>"))
        ]
        config.baseImports = ["<baseImport>"]
        config.baseTestImports = ["<baseTestImport>"]
        config.reactiveImports = ["<reactiveImport>"]
        config.dependencyInjectionImports = ["<dependencyInjectionImport>"]
        config.builderImports = ["<builderImport>"]
        config.flowImports = ["<flowImport>"]
        config.pluginListImports = ["<pluginListImport>"]
        config.viewControllerImports = ["<viewControllerImport>"]
        config.dependencies = [Variable(name: "<dependencyName>", type: "<dependencyType>")]
        config.analyticsProperties = [Variable(name: "<analyticsPropertyName>", type: "<analyticsPropertyType>")]
        config.flowProperties = [Variable(name: "<flowPropertyName>", type: "<flowPropertyType>")]
        config.viewControllableFlowType = "<viewControllableFlowType>"
        config.viewControllableType = "<viewControllableType>"
        config.viewControllableMockContents = "<viewControllableMockContents>"
        config.viewControllerStaticContent = "<viewControllerStaticContent>"
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
        config.isObservableStoreEnabled = true
        config.isViewInjectedTemplateEnabled = true
        config.isObservableStoreEnabled = false
        config.isPreviewProviderEnabled = true
        config.isTestTemplatesGenerationEnabled = true
        config.isPeripheryCommentEnabled = true
        return config
    }

    internal func givenNodeStencilContext(
        nodeName: String = "<nodeName>",
        includePlugin: Bool = false,
        mockCount: Int = 1
    ) throws -> NodeStencilContext {
        try NodeStencilContext(
            fileHeader: "<fileHeader>",
            nodeName: nodeName,
            pluginName: includePlugin ? nodeName : "",
            pluginListName: mockCount > 0 ? "<pluginListName>" : "",
            analyticsImports: .mock(with: "analyticsImport", count: mockCount),
            analyticsTestsImports: .mock(with: "analyticsTestsImport", count: mockCount),
            builderImports: .mock(with: "builderImport", count: mockCount),
            builderTestsImports: .mock(with: "builderTestsImport", count: mockCount),
            contextImports: .mock(with: "contextImport", count: mockCount),
            contextTestsImports: .mock(with: "contextTestsImport", count: mockCount),
            flowImports: .mock(with: "flowImport", count: mockCount),
            flowTestsImports: .mock(with: "flowTestsImport", count: mockCount),
            interfaceImports: .mock(with: "interfaceImport", count: mockCount),
            pluginImports: includePlugin ? .mock(with: "pluginImport", count: mockCount) : [],
            pluginInterfaceImports: includePlugin ? .mock(with: "pluginInterfaceImport", count: mockCount) : [],
            pluginTestsImports: includePlugin ? .mock(with: "pluginTestsImport", count: mockCount) : [],
            stateImports: .mock(with: "stateImport", count: mockCount),
            viewControllerImports: .mock(with: "viewControllerImport", count: mockCount),
            viewControllerTestsImports: .mock(with: "viewControllerTestsImport", count: mockCount),
            viewStateImports: .mock(with: "viewStateImport", count: mockCount),
            viewStateFactoryTestsImports: .mock(with: "viewStateFactoryTestsImport", count: mockCount),
            dependencies: .mock(with: "dependency", count: mockCount),
            analyticsProperties: .mock(with: "analyticsProperty", count: mockCount),
            flowProperties: .mock(with: "flowProperty", count: mockCount),
            viewControllableFlowType: "<viewControllableFlowType>",
            viewControllableType: "<viewControllableType>",
            viewControllableMockContents: mockCount > 0 ? "<viewControllableMockContents>" : "",
            viewControllerType: "<viewControllerType>",
            viewControllerSuperParameters: mockCount > 0 ? "<viewControllerSuperParameters>" : "",
            viewControllerMethods: mockCount > 0 ? "<viewControllerMethods>" : "",
            viewControllerStaticContent: mockCount > 0 ? "<viewControllerStaticContent>" : "",
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
            storePrefix: mockCount > 0 ? "<storePrefix>" : "",
            storePropertyWrapper: mockCount > 0 ? "<storePropertyWrapper>" : "",
            isPreviewProviderEnabled: mockCount > 0,
            isPeripheryCommentEnabled: mockCount > 0,
            isNimbleEnabled: mockCount > 0
        )
    }

    internal func givenNodeStencilContext(
        preset: Preset,
        mockCount: Int = 1
    ) throws -> NodeStencilContext {
        try NodeStencilContext(
            preset: preset,
            fileHeader: "<fileHeader>",
            analyticsImports: .mock(with: "analyticsImport", count: mockCount),
            analyticsTestsImports: .mock(with: "analyticsTestsImport", count: mockCount),
            builderImports: .mock(with: "builderImport", count: mockCount),
            builderTestsImports: .mock(with: "builderTestsImport", count: mockCount),
            contextImports: .mock(with: "contextImport", count: mockCount),
            contextTestsImports: .mock(with: "contextTestsImport", count: mockCount),
            flowImports: .mock(with: "flowImport", count: mockCount),
            flowTestsImports: .mock(with: "flowTestsImport", count: mockCount),
            interfaceImports: .mock(with: "interfaceImport", count: mockCount),
            stateImports: .mock(with: "stateImport", count: mockCount),
            viewControllerImports: .mock(with: "viewControllerImport", count: mockCount),
            viewControllerTestsImports: .mock(with: "viewControllerTestsImport", count: mockCount),
            viewStateImports: .mock(with: "viewStateImport", count: mockCount),
            viewStateFactoryTestsImports: .mock(with: "viewStateFactoryTestsImport", count: mockCount),
            dependencies: .mock(with: "dependency", count: mockCount),
            analyticsProperties: .mock(with: "analyticsProperty", count: mockCount),
            flowProperties: .mock(with: "flowProperty", count: mockCount),
            viewControllableFlowType: "<viewControllableFlowType>",
            viewControllableType: "<viewControllableType>",
            viewControllableMockContents: mockCount > 0 ? "<viewControllableMockContents>" : "",
            viewControllerType: "<viewControllerType>",
            viewControllerSuperParameters: mockCount > 0 ? "<viewControllerSuperParameters>" : "",
            viewControllerMethods: mockCount > 0 ? "<viewControllerMethods>" : "",
            viewControllerStaticContent: mockCount > 0 ? "<viewControllerStaticContent>" : "",
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
            storePrefix: mockCount > 0 ? "<storePrefix>" : "",
            storePropertyWrapper: mockCount > 0 ? "<storePropertyWrapper>" : "",
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
            pluginName: nodeName,
            analyticsImports: .mock(with: "analyticsImport", count: mockCount),
            analyticsTestsImports: .mock(with: "analyticsTestsImport", count: mockCount),
            builderImports: .mock(with: "builderImport", count: mockCount),
            builderTestsImports: .mock(with: "builderTestsImport", count: mockCount),
            contextImports: .mock(with: "contextImport", count: mockCount),
            contextTestsImports: .mock(with: "contextTestsImport", count: mockCount),
            flowImports: .mock(with: "flowImport", count: mockCount),
            flowTestsImports: .mock(with: "flowTestsImport", count: mockCount),
            interfaceImports: .mock(with: "interfaceImport", count: mockCount),
            pluginImports: .mock(with: "pluginImport", count: mockCount),
            pluginInterfaceImports: .mock(with: "pluginInterfaceImport", count: mockCount),
            pluginTestsImports: .mock(with: "pluginTestsImport", count: mockCount),
            stateImports: .mock(with: "stateImport", count: mockCount),
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

    internal func givenNodeViewInjectedStencilContext(
        preset: Preset,
        mockCount: Int = 1
    ) throws -> NodeViewInjectedStencilContext {
        try NodeViewInjectedStencilContext(
            preset: preset,
            fileHeader: "<fileHeader>",
            analyticsImports: .mock(with: "analyticsImport", count: mockCount),
            analyticsTestsImports: .mock(with: "analyticsTestsImport", count: mockCount),
            builderImports: .mock(with: "builderImport", count: mockCount),
            builderTestsImports: .mock(with: "builderTestsImport", count: mockCount),
            contextImports: .mock(with: "contextImport", count: mockCount),
            contextTestsImports: .mock(with: "contextTestsImport", count: mockCount),
            flowImports: .mock(with: "flowImport", count: mockCount),
            flowTestsImports: .mock(with: "flowTestsImport", count: mockCount),
            interfaceImports: .mock(with: "interfaceImport", count: mockCount),
            pluginImports: .mock(with: "pluginImport", count: mockCount),
            pluginInterfaceImports: .mock(with: "pluginInterfaceImports", count: mockCount),
            pluginTestsImports: .mock(with: "pluginTestsImport", count: mockCount),
            stateImports: .mock(with: "stateImport", count: mockCount),
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

    internal func givenPluginStencilContext(
        mockCount: Int = 1
    ) -> PluginStencilContext {
        PluginStencilContext(
            fileHeader: "<fileHeader>",
            pluginName: "<pluginName>",
            pluginImports: .mock(with: "pluginImport", count: mockCount),
            pluginTestsImports: .mock(with: "pluginTestsImport", count: mockCount),
            isPeripheryCommentEnabled: mockCount > 0,
            isNimbleEnabled: mockCount > 0
        )
    }

    internal func givenPluginListStencilContext(
        mockCount: Int = 1
    ) -> PluginListStencilContext {
        PluginListStencilContext(
            fileHeader: "<fileHeader>",
            pluginListName: "<pluginListName>",
            pluginListImports: .mock(with: "pluginListImport", count: mockCount),
            pluginListTestsImports: .mock(with: "pluginListTestsImports", count: mockCount),
            viewControllableFlowType: "<viewControllableFlowType>",
            isPeripheryCommentEnabled: mockCount > 0,
            isNimbleEnabled: mockCount > 0
        )
    }

    internal func givenWorkerStencilContext(
        mockCount: Int = 1
    ) -> WorkerStencilContext {
        WorkerStencilContext(
            fileHeader: "<fileHeader>",
            workerName: "<workerName>",
            workerImports: .mock(with: "workerImport", count: mockCount),
            workerTestsImports: .mock(with: "workerTestsImport", count: mockCount),
            workerGenericTypes: .mock(with: "workerGenericType", count: mockCount),
            isPeripheryCommentEnabled: mockCount > 0,
            isNimbleEnabled: mockCount > 0
        )
    }
}
