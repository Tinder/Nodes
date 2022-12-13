//
//  TestFactories.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Christopher Fuller on 5/31/21.
//

@testable import XcodeTemplateGeneratorLibrary

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
            UIFramework(framework: .custom(name: "<name>",
                                           import: "<import>",
                                           viewControllerType: "<viewControllerType>",
                                           viewControllerSuperParameters: "<viewControllerSuperParameters>"))
        ].map {
            var uiFramework: UIFramework = $0
            uiFramework.viewControllerProperties = "<viewControllerProperties>"
            uiFramework.viewControllerMethods = "<viewControllerMethods>"
            uiFramework.viewControllerMethodsForRootNode = "<viewControllerMethodsForRootNode>"
            return uiFramework
        }
        config.fileHeader = "<fileHeader>"
        config.reactiveImports = ["<reactiveImports>"]
        config.dependencyInjectionImports = ["<dependencyInjectionImports>"]
        config.dependencies = [Variable(name: "<dependenciesName>", type: "<dependenciesType>")]
        config.flowProperties = [Variable(name: "<flowPropertiesName>", type: "<flowPropertiesType>")]
        config.viewControllableType = "<viewControllableType>"
        config.viewControllableFlowType = "<viewControllableFlowType>"
        config.viewControllerUpdateComment = "<viewControllerUpdateComment>"
        config.viewStatePublisher = "<viewStatePublisher>"
        config.viewStateOperators = "<viewStateOperators>"
        config.publisherType = "<publisherType>"
        config.publisherFailureType = "<publisherFailureType>"
        config.cancellableType = "<cancellableType>"
        return config
    }

    func givenNodeContext() -> NodeContext {
        NodeContext(
            fileHeader: "<fileHeader>",
            nodeName: "<nodeName>",
            workerName: "<workerName>",
            builderImports: ["<builderImports>"],
            contextImports: ["<contextImports>"],
            flowImports: ["<flowImports>"],
            viewControllerImports: ["<viewControllerImports>"],
            workerImports: ["<workerImports>"],
            dependencies: [Variable(name: "<dependenciesName>", type: "<dependenciesType>")],
            flowProperties: [Variable(name: "<flowPropertiesName>", type: "<flowPropertiesType>")],
            viewControllerType: "<viewControllerType>",
            viewControllableType: "<viewControllableType>",
            viewControllableFlowType: "<viewControllableFlowType>",
            viewControllerSuperParameters: "<viewControllerSuperParameters>",
            viewControllerProperties: "<viewControllerProperties>",
            viewControllerMethods: "<viewControllerMethods>",
            viewControllerUpdateComment: "<viewControllerUpdateComment>",
            viewStatePublisher: "<viewStatePublisher>",
            viewStateOperators: "<viewStateOperators>",
            publisherType: "<publisherType>",
            publisherFailureType: "<publisherFailureType>",
            cancellableType: "<cancellableType>"
        )
    }

    func givenNodeRootContext() -> NodeRootContext {
        NodeRootContext(
            fileHeader: "<fileHeader>",
            workerName: "<workerName>",
            builderImports: ["<builderImports>"],
            contextImports: ["<contextImports>"],
            flowImports: ["<flowImports>"],
            viewControllerImports: ["<viewControllerImports>"],
            workerImports: ["<workerImports>"],
            dependencies: [Variable(name: "<dependenciesName>", type: "<dependenciesType>")],
            flowProperties: [Variable(name: "<flowPropertiesName>", type: "<flowPropertiesType>")],
            viewControllerType: "<viewControllerType>",
            viewControllableType: "<viewControllableType>",
            viewControllableFlowType: "<viewControllableFlowType>",
            viewControllerSuperParameters: "<viewControllerSuperParameters>",
            viewControllerProperties: "<viewControllerProperties>",
            viewControllerMethods: "<viewControllerMethods>",
            viewControllerUpdateComment: "<viewControllerUpdateComment>",
            viewStatePublisher: "<viewStatePublisher>",
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
            workerName: "<workerName>",
            builderImports: ["<builderImports>"],
            contextImports: ["<contextImports>"],
            flowImports: ["<flowImports>"],
            workerImports: ["<workerImports>"],
            dependencies: [Variable(name: "<dependenciesName>", type: "<dependenciesType>")],
            flowProperties: [Variable(name: "<flowPropertiesName>", type: "<flowPropertiesType>")],
            viewControllableType: "<viewControllableType>",
            viewControllableFlowType: "<viewControllableFlowType>",
            cancellableType: "<cancellableType>"
        )
    }

    func givenPluginContext() -> PluginContext {
        PluginContext(
            fileHeader: "<fileHeader>",
            pluginName: "<pluginName>",
            returnType: "<returnType>",
            pluginImports: ["<pluginImports>"]
        )
    }

    func givenPluginContextWithoutReturnType() -> PluginContext {
        PluginContext(
            fileHeader: "<fileHeader>",
            pluginName: "<pluginName>",
            pluginImports: ["<pluginImports>"]
        )
    }

    func givenPluginListContext() -> PluginListContext {
        PluginListContext(
            fileHeader: "<fileHeader>",
            pluginListName: "<pluginListName>",
            pluginListImports: ["<pluginListImports>"],
            viewControllableFlowType: "<viewControllableFlowType>"
        )
    }

    func givenWorkerContext() -> WorkerContext {
        WorkerContext(
            fileHeader: "<fileHeader>",
            nodeName: "<nodeName>",
            workerName: "<workerName>",
            workerImports: ["<workerImports>"],
            cancellableType: "<cancellableType>"
        )
    }
}
