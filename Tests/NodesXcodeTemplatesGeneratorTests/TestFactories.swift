//
//  TestFactories.swift
//  NodesXcodeTemplatesGeneratorTests
//
//  Created by Christopher Fuller on 5/31/21.
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
        ].map {
            var uiFramework: UIFramework = $0
            uiFramework.viewControllerProperties = "<viewControllerProperties>"
            uiFramework.viewControllerMethods = "<viewControllerMethods>"
            uiFramework.viewControllerMethodsForRootNode = "<viewControllerMethodsForRootNode>"
            return uiFramework
        }
        config.fileHeader = "<fileHeader>"
        config.baseImports = ["<baseImports>"]
        config.reactiveImports = ["<reactiveImports>"]
        config.dependencyInjectionImports = ["<dependencyInjectionImports>"]
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

    func givenNodeContext(
        imports: Int = 1,
        dependencies: Int = 1,
        flowProperties: Int = 1,
        viewControllerProperties: String = "<viewControllerProperties>",
        viewControllerMethods: String = "<viewControllerMethods>",
        viewStateOperators: String = "<viewStateOperators>"
    ) -> NodeContext {
        NodeContext(
            fileHeader: "<fileHeader>",
            nodeName: "<nodeName>",
            analyticsImports: Set((0..<imports).map { "<analyticsImport\($0 + 1)>" }),
            builderImports: Set((0..<imports).map { "<builderImport\($0 + 1)>" }),
            contextImports: Set((0..<imports).map { "<contextImport\($0 + 1)>" }),
            flowImports: Set((0..<imports).map { "<flowImport\($0 + 1)>" }),
            stateImports: Set((0..<imports).map { "<stateImport\($0 + 1)>" }),
            viewControllerImports: Set((0..<imports).map { "<viewControllerImport\($0 + 1)>" }),
            viewStateImports: Set((0..<imports).map { "<viewStateImport\($0 + 1)>" }),
            dependencies: (0..<dependencies).map {
                Variable(name: "<dependencyName\($0 + 1)>", type: "<dependencyType\($0 + 1)>")
            },
            flowProperties: (0..<flowProperties).map {
                Variable(name: "<flowPropertyName\($0 + 1)>", type: "<flowPropertyType\($0 + 1)>")
            },
            viewControllerType: "<viewControllerType>",
            viewControllableType: "<viewControllableType>",
            viewControllableFlowType: "<viewControllableFlowType>",
            viewControllerSuperParameters: "<viewControllerSuperParameters>",
            viewControllerProperties: viewControllerProperties,
            viewControllerMethods: viewControllerMethods,
            viewControllerUpdateComment: "<viewControllerUpdateComment>",
            viewStateOperators: viewStateOperators,
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

    func givenNodeViewInjectedContext(flowProperties: Int = 1) -> NodeViewInjectedContext {
        NodeViewInjectedContext(
            fileHeader: "<fileHeader>",
            nodeName: "<nodeName>",
            analyticsImports: ["<analyticsImports>"],
            builderImports: ["<builderImports>"],
            contextImports: ["<contextImports>"],
            flowImports: ["<flowImports>"],
            stateImports: ["<stateImports>"],
            dependencies: [Variable(name: "<dependenciesName>", type: "<dependenciesType>")],
            flowProperties: (0..<flowProperties).map {
                Variable(name: "<flowPropertyName\($0 + 1)>", type: "<flowPropertyType\($0 + 1)>")
            },
            viewControllableType: "<viewControllableType>",
            viewControllableFlowType: "<viewControllableFlowType>",
            cancellableType: "<cancellableType>"
        )
    }

    func givenPluginContext(imports: Int = 1) -> PluginContext {
        PluginContext(
            fileHeader: "<fileHeader>",
            pluginName: "<pluginName>",
            returnType: "<returnType>",
            pluginImports: Set((0..<imports).map { "<pluginImport\($0 + 1)>" })
        )
    }

    func givenPluginContextWithoutReturnType() -> PluginContext {
        PluginContext(
            fileHeader: "<fileHeader>",
            pluginName: "<pluginName>",
            pluginImports: ["<pluginImports>"]
        )
    }

    func givenPluginListContext(imports: Int = 1) -> PluginListContext {
        PluginListContext(
            fileHeader: "<fileHeader>",
            pluginListName: "<pluginListName>",
            pluginListImports: Set((0..<imports).map { "<pluginListImport\($0 + 1)>" }),
            viewControllableFlowType: "<viewControllableFlowType>"
        )
    }

    func givenWorkerContext(imports: Int = 1) -> WorkerContext {
        WorkerContext(
            fileHeader: "<fileHeader>",
            workerName: "<workerName>",
            workerImports: Set((0..<imports).map { "<workerImport\($0 + 1)>" }),
            cancellableType: "<cancellableType>"
        )
    }
}
