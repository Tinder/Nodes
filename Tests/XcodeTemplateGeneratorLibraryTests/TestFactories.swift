//
//  TestFactories.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Christopher Fuller on 5/31/21.
//

import XcodeTemplateGeneratorLibrary

protocol TestFactories {}

extension TestFactories {

    typealias Variable = XcodeTemplates.Variable
    typealias Config = XcodeTemplates.Config

    func givenConfig() -> Config {
        var config: Config = .init()
        config.includedTemplates = ["<includedTemplates>"]
        config.fileHeader = "<fileHeader>"
        config.baseImports = ["<baseImports>"]
        config.diGraphImports = ["<diGraphImports>"]
        config.viewControllerImports = ["<viewControllerImports>"]
        config.viewControllerImportsSwiftUI = ["<viewControllerImportsSwiftUI>"]
        config.dependencies = [Variable(name: "<dependenciesName>", type: "<dependenciesType>")]
        config.flowProperties = [Variable(name: "<flowPropertiesName>", type: "<flowPropertiesType>")]
        config.viewControllerType = "<viewControllerType>"
        config.viewControllableType = "<viewControllableType>"
        config.viewControllableFlowType = "<viewControllableFlowType>"
        config.viewControllerSuperParameters = "<viewControllerSuperParameters>"
        config.viewControllerProperties = "<viewControllerProperties>"
        config.viewControllerPropertiesSwiftUI = "<viewControllerPropertiesSwiftUI>"
        config.viewControllerMethods = "<viewControllerMethods>"
        config.viewControllerMethodsSwiftUI = "<viewControllerMethodsSwiftUI>"
        config.rootViewControllerMethods = "<rootViewControllerMethods>"
        config.rootViewControllerMethodsSwiftUI = "<rootViewControllerMethodsSwiftUI>"
        config.viewControllerWithoutViewStateMethods = "<viewControllerWithoutViewStateMethods>"
        config.viewControllerWithoutViewStateMethodsSwiftUI = "<viewControllerWithoutViewStateMethodsSwiftUI>"
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
            publicNode: true,
            rootNode: true,
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

    func givenNodeWithoutViewContext() -> NodeWithoutViewContext {
        NodeWithoutViewContext(
            fileHeader: "<fileHeader>",
            nodeName: "<nodeName>",
            workerName: "<workerName>",
            publicNode: true,
            rootNode: true,
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

    func givenNodeWithoutViewStateContext() -> NodeWithoutViewStateContext {
        NodeWithoutViewStateContext(
            fileHeader: "<fileHeader>",
            nodeName: "<nodeName>",
            workerName: "<workerName>",
            publicNode: true,
            rootNode: true,
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

    func givenPluginMapContext() -> PluginMapContext {
        PluginMapContext(
            fileHeader: "<fileHeader>",
            pluginMapName: "<pluginMapName>",
            pluginMapImports: ["<pluginMapImports>"],
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
