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
        config.analyticsImports = ["<analyticsImports>"]
        config.builderImports = ["<builderImports>"]
        config.contextImports = ["<contextImports>"]
        config.flowImports = ["<flowImports>"]
        config.pluginImports = ["<pluginImports>"]
        config.pluginListImports = ["<pluginListImports>"]
        config.stateImports = ["<stateImports>"]
        config.viewControllerImports = ["<viewControllerImports>"]
        config.viewControllerImportsSwiftUI = ["<viewControllerImportsSwiftUI>"]
        config.viewStateImports = ["<viewStateImports>"]
        config.workerImports = ["<workerImports>"]
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
        config.viewControllerUpdateComment = "<viewControllerUpdateComment>"
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
            analyticsImports: ["<analyticsImports>"],
            builderImports: ["<builderImports>"],
            contextImports: ["<contextImports>"],
            flowImports: ["<flowImports>"],
            stateImports: ["<stateImports>"],
            viewControllerImports: ["<viewControllerImports>"],
            viewStateImports: ["<viewStateImports>"],
            dependencies: [Variable(name: "<dependenciesName>", type: "<dependenciesType>")],
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
            analyticsImports: ["<analyticsImports>"],
            builderImports: ["<builderImports>"],
            contextImports: ["<contextImports>"],
            flowImports: ["<flowImports>"],
            stateImports: ["<stateImports>"],
            viewControllerImports: ["<viewControllerImports>"],
            viewStateImports: ["<viewStateImports>"],
            dependencies: [Variable(name: "<dependenciesName>", type: "<dependenciesType>")],
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
            analyticsImports: ["<analyticsImports>"],
            builderImports: ["<builderImports>"],
            contextImports: ["<contextImports>"],
            flowImports: ["<flowImports>"],
            stateImports: ["<stateImports>"],
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
