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
        config.flowProperties = [Variable(name: "<flowPropertiesName>", type: "<flowPropertiesType>")]
        config.viewControllableType = "<viewControllableType>"
        config.viewControllableFlowType = "<viewControllableFlowType>"
        config.viewControllerUpdateComment = "<viewControllerUpdateComment>"
        config.viewStateOperators = "<viewStateOperators>"
        config.publisherType = "<publisherType>"
        config.publisherFailureType = "<publisherFailureType>"
        config.cancellableType = "<cancellableType>"
        return config
    }

    func givenNodeContext(mockCount: Int = 1) -> NodeContext {
        NodeContext(
            fileHeader: "<fileHeader>",
            nodeName: "<nodeName>",
            analyticsImports: .mock(with: "analyticsImport", count: mockCount),
            builderImports: .mock(with: "builderImport", count: mockCount),
            contextImports: .mock(with: "contextImport", count: mockCount),
            flowImports: .mock(with: "flowImport", count: mockCount),
            stateImports: .mock(with: "stateImport", count: mockCount),
            viewControllerImports: .mock(with: "viewControllerImport", count: mockCount),
            viewStateImports: .mock(with: "viewStateImport", count: mockCount),
            dependencies: [Variable(name: "<dependencyName>", type: "<dependencyType>")],
            analyticsProperties: [Variable(name: "<analyticsPropertyName>", type: "<analyticsPropertyType>")],
            flowProperties: .mock(with: "flowProperty", count: mockCount),
            viewControllerType: "<viewControllerType>",
            viewControllableType: "<viewControllableType>",
            viewControllableFlowType: "<viewControllableFlowType>",
            viewControllerSuperParameters: "<viewControllerSuperParameters>",
            viewControllerProperties: "<viewControllerProperties>",
            viewControllerMethods: "<viewControllerMethods>",
            viewControllerUpdateComment: "<viewControllerUpdateComment>",
            viewStateOperators: "<viewStateOperators>",
            publisherType: "<publisherType>",
            publisherFailureType: "<publisherFailureType>",
            cancellableType: "<cancellableType>"
        )
    }

    func givenNodeRootContext(mockCount: Int = 1) -> NodeRootContext {
        NodeRootContext(
            fileHeader: "<fileHeader>",
            analyticsImports: .mock(with: "analyticsImport", count: mockCount),
            builderImports: .mock(with: "builderImport", count: mockCount),
            contextImports: .mock(with: "contextImport", count: mockCount),
            flowImports: .mock(with: "flowImport", count: mockCount),
            stateImports: .mock(with: "stateImport", count: mockCount),
            viewControllerImports: .mock(with: "viewControllerImport", count: mockCount),
            viewStateImports: .mock(with: "viewStateImport", count: mockCount),
            dependencies: [Variable(name: "<dependencyName>", type: "<dependencyType>")],
            analyticsProperties: [Variable(name: "<analyticsPropertyName>", type: "<analyticsPropertyType>")],
            flowProperties: .mock(with: "flowProperty", count: mockCount),
            viewControllerType: "<viewControllerType>",
            viewControllableType: "<viewControllableType>",
            viewControllableFlowType: "<viewControllableFlowType>",
            viewControllerSuperParameters: "<viewControllerSuperParameters>",
            viewControllerProperties: "<viewControllerProperties>",
            viewControllerMethods: "<viewControllerMethods>",
            viewControllerUpdateComment: "<viewControllerUpdateComment>",
            viewStateOperators: "<viewStateOperators>",
            publisherType: "<publisherType>",
            publisherFailureType: "<publisherFailureType>",
            cancellableType: "<cancellableType>"
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
            dependencies: [Variable(name: "<dependencyName>", type: "<dependencyType>")],
            analyticsProperties: [Variable(name: "<analyticsPropertyName>", type: "<analyticsPropertyType>")],
            flowProperties: .mock(with: "flowProperty", count: mockCount),
            viewControllableType: "<viewControllableType>",
            viewControllableFlowType: "<viewControllableFlowType>",
            cancellableType: "<cancellableType>"
        )
    }

    func givenPluginContext(mockCount: Int = 1) -> PluginContext {
        PluginContext(
            fileHeader: "<fileHeader>",
            pluginName: "<pluginName>",
            returnType: "<returnType>",
            pluginImports: .mock(with: "pluginImport", count: mockCount)
        )
    }

    func givenPluginContextWithoutReturnType(mockCount: Int = 1) -> PluginContext {
        PluginContext(
            fileHeader: "<fileHeader>",
            pluginName: "<pluginName>",
            pluginImports: .mock(with: "pluginImport", count: mockCount)
        )
    }

    func givenPluginListContext(mockCount: Int = 1) -> PluginListContext {
        PluginListContext(
            fileHeader: "<fileHeader>",
            pluginListName: "<pluginListName>",
            pluginListImports: .mock(with: "pluginListImport", count: mockCount),
            viewControllableFlowType: "<viewControllableFlowType>"
        )
    }

    func givenWorkerContext(mockCount: Int = 1) -> WorkerContext {
        WorkerContext(
            fileHeader: "<fileHeader>",
            workerName: "<workerName>",
            workerImports: .mock(with: "workerImport", count: mockCount),
            cancellableType: "<cancellableType>"
        )
    }
}
