//
//  NodeWithPluginTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 6/6/22.
//

internal struct NodeWithPluginTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String = "Node with Plugin"
    internal let type: String = "Node"
    internal let stencils: [String] = ["Analytics", "Builder", "Context", "Flow", "Plugin", "ViewController", "Worker"]
    internal let filenames: [String: String] = ["Worker": "ViewStateWorker"]
    internal let context: Context

    internal let propertyList: PropertyList =
        .init(description: "The source files implementing a Node.",
              sortOrder: 1) {
            Option(identifier: "productName",
                   name: "Node name:",
                   description: "The name of the Node")
        }

    internal init(config: Config, swiftUI: Bool = false) {
        context = NodeWithPluginContext(
            fileHeader: config.fileHeader,
            nodeName: config.variable("productName"),
            pluginName: config.variable("productName"),
            workerName: "\(config.variable("productName"))ViewState",
            builderImports: config.imports(for: .diGraph),
            contextImports: config.imports(for: .nodes),
            flowImports: config.imports(for: .nodes),
            pluginImports: config.imports(for: .diGraph),
            viewControllerImports: config.imports(for: .viewController(viewState: true, swiftUI: swiftUI)),
            workerImports: config.imports(for: .nodes),
            dependencies: config.dependencies,
            flowProperties: config.flowProperties,
            viewControllerType: config.viewControllerType,
            viewControllableType: config.viewControllableType,
            viewControllableFlowType: config.viewControllableFlowType,
            viewControllerSuperParameters: config.viewControllerSuperParameters,
            viewControllerProperties: config.viewControllerProperties(swiftUI: swiftUI),
            viewControllerMethods: config.viewControllerMethods(for: .standard(swiftUI: swiftUI)),
            viewControllerUpdateComment: config.viewControllerUpdateComment,
            viewStatePublisher: config.viewStatePublisher,
            viewStateOperators: config.viewStateOperators,
            publisherType: config.publisherType,
            publisherFailureType: config.publisherFailureType,
            cancellableType: config.cancellableType,
            returnType: config.variable("returnType")
        )
    }
}

