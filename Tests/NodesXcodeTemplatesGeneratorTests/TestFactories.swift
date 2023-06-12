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

    func givenNodeContext(importCount: Int = 1) -> NodeContext {
        NodeContext(
            fileHeader: "<fileHeader>",
            nodeName: "<nodeName>",
            analyticsImports: .mock(with: "analyticsImport", count: importCount),
            builderImports: .mock(with: "builderImport", count: importCount),
            contextImports: .mock(with: "contextImport", count: importCount),
            flowImports: .mock(with: "flowImport", count: importCount),
            stateImports: .mock(with: "stateImport", count: importCount),
            viewControllerImports: .mock(with: "viewControllerImport", count: importCount),
            viewStateImports: .mock(with: "viewStateImport", count: importCount),
            dependencies: [Variable(name: "<dependenciesName>", type: "<dependenciesType>")],
            analyticsProperties: [Variable(name: "<analyticsPropertiesName>", type: "<analyticsPropertiesType>")],
            flowProperties: [Variable(name: "<flowPropertiesName>", type: "<flowPropertiesType>")],
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

    func givenNodeRootContext() -> NodeRootContext {
        NodeRootContext(
            fileHeader: "<fileHeader>",
            analyticsImports: ["<analyticsImport>"],
            builderImports: ["<builderImport>"],
            contextImports: ["<contextImport>"],
            flowImports: ["<flowImport>"],
            stateImports: ["<stateImport>"],
            viewControllerImports: ["<viewControllerImport>"],
            viewStateImports: ["<viewStateImport>"],
            dependencies: [Variable(name: "<dependenciesName>", type: "<dependenciesType>")],
            analyticsProperties: [Variable(name: "<analyticsPropertiesName>", type: "<analyticsPropertiesType>")],
            flowProperties: [Variable(name: "<flowPropertiesName>", type: "<flowPropertiesType>")],
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

    func givenNodeViewInjectedContext() -> NodeViewInjectedContext {
        NodeViewInjectedContext(
            fileHeader: "<fileHeader>",
            nodeName: "<nodeName>",
            analyticsImports: ["<analyticsImport>"],
            builderImports: ["<builderImport>"],
            contextImports: ["<contextImport>"],
            flowImports: ["<flowImport>"],
            stateImports: ["<stateImport>"],
            dependencies: [Variable(name: "<dependenciesName>", type: "<dependenciesType>")],
            analyticsProperties: [Variable(name: "<analyticsPropertiesName>", type: "<analyticsPropertiesType>")],
            flowProperties: [Variable(name: "<flowPropertiesName>", type: "<flowPropertiesType>")],
            viewControllableType: "<viewControllableType>",
            viewControllableFlowType: "<viewControllableFlowType>",
            cancellableType: "<cancellableType>"
        )
    }

    func givenPluginContext(importCount: Int = 1) -> PluginContext {
        PluginContext(
            fileHeader: "<fileHeader>",
            pluginName: "<pluginName>",
            returnType: "<returnType>",
            pluginImports: .mock(with: "pluginImport", count: importCount)
        )
    }

    func givenPluginContextWithoutReturnType(importCount: Int = 1) -> PluginContext {
        PluginContext(
            fileHeader: "<fileHeader>",
            pluginName: "<pluginName>",
            pluginImports: .mock(with: "pluginImport", count: importCount)
        )
    }

    func givenPluginListContext(importCount: Int = 1) -> PluginListContext {
        PluginListContext(
            fileHeader: "<fileHeader>",
            pluginListName: "<pluginListName>",
            pluginListImports: .mock(with: "pluginListImport", count: importCount),
            viewControllableFlowType: "<viewControllableFlowType>"
        )
    }

    func givenWorkerContext(importCount: Int = 1) -> WorkerContext {
        WorkerContext(
            fileHeader: "<fileHeader>",
            workerName: "<workerName>",
            workerImports: .mock(with: "workerImport", count: importCount),
            cancellableType: "<cancellableType>"
        )
    }
}
