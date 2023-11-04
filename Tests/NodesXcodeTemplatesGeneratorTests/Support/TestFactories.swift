//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

@testable import NodesXcodeTemplatesGenerator

protocol TestFactories {}

extension TestFactories {

    typealias Variable = XcodeTemplates.Variable
    typealias Config = XcodeTemplates.Config

    func givenConfig() -> Config {
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
            uiFramework.viewControllerMethodsForRootNode = "<viewControllerMethodsForRootNode>"
            return uiFramework
        }
        config.fileHeader = "<fileHeader>"
        config.baseImports = ["<baseImport>"]
        config.reactiveImports = ["<reactiveImport>"]
        config.dependencyInjectionImports = ["<dependencyInjectionImport>"]
        config.dependencies = [Variable(name: "<dependenciesName>", type: "<dependenciesType>")]
        config.analyticsProperties = [Variable(name: "<analyticsPropertiesName>", type: "<analyticsPropertiesType>")]
        config.flowProperties = [Variable(name: "<flowPropertiesName>", type: "<flowPropertiesType>")]
        config.viewControllableType = "<viewControllableType>"
        config.viewControllableFlowType = "<viewControllableFlowType>"
        config.viewControllerSubscriptionsProperty = "<viewControllerSubscriptionsProperty>"
        config.viewControllerUpdateComment = "<viewControllerUpdateComment>"
        config.viewStateEmptyFactory = "<viewStateEmptyFactory>"
        config.viewStateOperators = "<viewStateOperators>"
        config.viewStateTransform = "<viewStateTransform>"
        config.publisherType = "<publisherType>"
        config.publisherFailureType = "<publisherFailureType>"
        config.contextGenericTypes = ["<contextGenericType>"]
        config.workerGenericTypes = ["<workerGenericType>"]
        return config
    }

    func givenNodeContext(mockCount: Int = 1) -> NodeContext {
        let isStringIdentifierMocked: Bool = mockCount > 0
        return NodeContext(
            fileHeader: "<fileHeader>",
            nodeName: "<nodeName>",
            analyticsImports: .mock(with: "analyticsImport", count: mockCount),
            builderImports: .mock(with: "builderImport", count: mockCount),
            contextImports: .mock(with: "contextImport", count: mockCount),
            flowImports: .mock(with: "flowImport", count: mockCount),
            stateImports: .mock(with: "stateImport", count: mockCount),
            viewControllerImports: .mock(with: "viewControllerImport", count: mockCount),
            viewStateImports: .mock(with: "viewStateImport", count: mockCount),
            dependencies: .mock(with: "dependency", count: mockCount),
            analyticsProperties: .mock(with: "analyticsProperty", count: mockCount),
            flowProperties: .mock(with: "flowProperty", count: mockCount),
            viewControllerType: "<viewControllerType>",
            viewControllableType: "<viewControllableType>",
            viewControllableFlowType: "<viewControllableFlowType>",
            viewControllerSuperParameters: isStringIdentifierMocked ? "<viewControllerSuperParameters>" : "",
            viewControllerProperties: isStringIdentifierMocked ? "<viewControllerProperties>" : "",
            viewControllerMethods: isStringIdentifierMocked ? "<viewControllerMethods>" : "",
            viewControllerUpdateComment: isStringIdentifierMocked ? "<viewControllerUpdateComment>" : "",
            viewStateOperators: isStringIdentifierMocked ? "<viewStateOperators>" : "",
            publisherType: "<publisherType>",
            publisherFailureType: isStringIdentifierMocked ? "<publisherFailureType>" : "",
            contextGenericTypes: .mock(with: "contextGenericType", count: mockCount),
            workerGenericTypes: .mock(with: "workerGenericType", count: mockCount),
            isPeripheryCommentEnabled: mockCount > 0
        )
    }

    func givenNodeRootContext(mockCount: Int = 1) -> NodeRootContext {
        let isStringIdentifierMocked: Bool = mockCount > 0
        return NodeRootContext(
            fileHeader: "<fileHeader>",
            analyticsImports: .mock(with: "analyticsImport", count: mockCount),
            builderImports: .mock(with: "builderImport", count: mockCount),
            contextImports: .mock(with: "contextImport", count: mockCount),
            flowImports: .mock(with: "flowImport", count: mockCount),
            stateImports: .mock(with: "stateImport", count: mockCount),
            viewControllerImports: .mock(with: "viewControllerImport", count: mockCount),
            viewStateImports: .mock(with: "viewStateImport", count: mockCount),
            dependencies: .mock(with: "dependency", count: mockCount),
            analyticsProperties: .mock(with: "analyticsProperty", count: mockCount),
            flowProperties: .mock(with: "flowProperty", count: mockCount),
            viewControllerType: "<viewControllerType>",
            viewControllableType: "<viewControllableType>",
            viewControllableFlowType: "<viewControllableFlowType>",
            viewControllerSuperParameters: isStringIdentifierMocked ? "<viewControllerSuperParameters>" : "",
            viewControllerProperties: isStringIdentifierMocked ? "<viewControllerProperties>" : "",
            viewControllerMethods: isStringIdentifierMocked ? "<viewControllerMethods>" : "",
            viewControllerUpdateComment: isStringIdentifierMocked ? "<viewControllerUpdateComment>" : "",
            viewStateOperators: isStringIdentifierMocked ? "<viewStateOperators>" : "",
            publisherType: "<publisherType>",
            publisherFailureType: isStringIdentifierMocked ? "<publisherFailureType>" : "",
            contextGenericTypes: .mock(with: "contextGenericType", count: mockCount),
            workerGenericTypes: .mock(with: "workerGenericType", count: mockCount),
            isPeripheryCommentEnabled: mockCount > 0
        )
    }

    func givenNodeViewInjectedContext(mockCount: Int = 1) -> NodeViewInjectedContext {
        NodeViewInjectedContext(
            fileHeader: "<fileHeader>",
            nodeName: "<nodeName>",
            analyticsImports: .mock(with: "analyticsImport", count: mockCount),
            builderImports: .mock(with: "builderImport", count: mockCount),
            contextImports: .mock(with: "contextImport", count: mockCount),
            flowImports: .mock(with: "flowImport", count: mockCount),
            stateImports: .mock(with: "stateImport", count: mockCount),
            dependencies: .mock(with: "dependency", count: mockCount),
            analyticsProperties: .mock(with: "analyticsProperty", count: mockCount),
            flowProperties: .mock(with: "flowProperty", count: mockCount),
            viewControllableType: "<viewControllableType>",
            viewControllableFlowType: "<viewControllableFlowType>",
            contextGenericTypes: .mock(with: "contextGenericType", count: mockCount),
            workerGenericTypes: .mock(with: "workerGenericType", count: mockCount),
            isPeripheryCommentEnabled: mockCount > 0
        )
    }

    func givenPluginContext(mockCount: Int = 1) -> PluginContext {
        PluginContext(
            fileHeader: "<fileHeader>",
            pluginName: "<pluginName>",
            returnType: "<returnType>",
            pluginImports: .mock(with: "pluginImport", count: mockCount),
            isPeripheryCommentEnabled: mockCount > 0
        )
    }

    func givenPluginContextWithoutReturnType(mockCount: Int = 1) -> PluginContext {
        PluginContext(
            fileHeader: "<fileHeader>",
            pluginName: "<pluginName>",
            pluginImports: .mock(with: "pluginImport", count: mockCount),
            isPeripheryCommentEnabled: mockCount > 0
        )
    }

    func givenPluginListContext(mockCount: Int = 1) -> PluginListContext {
        PluginListContext(
            fileHeader: "<fileHeader>",
            pluginListName: "<pluginListName>",
            pluginListImports: .mock(with: "pluginListImport", count: mockCount),
            viewControllableFlowType: "<viewControllableFlowType>",
            isPeripheryCommentEnabled: mockCount > 0
        )
    }

    func givenWorkerContext(mockCount: Int = 1) -> WorkerContext {
        WorkerContext(
            fileHeader: "<fileHeader>",
            workerName: "<workerName>",
            workerImports: .mock(with: "workerImport", count: mockCount),
            workerGenericTypes: .mock(with: "workerGenericType", count: mockCount),
            isPeripheryCommentEnabled: mockCount > 0
        )
    }
}
