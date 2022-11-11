//
//  NodeTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

internal struct NodeTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String
    internal let stencils: [String]
    internal let filenames: [String: String]
    internal let context: Context

    internal let propertyList: PropertyList =
        .init(description: "The source files implementing a Node.",
              sortOrder: 1) {
            Option(identifier: "productName",
                   name: "Node name:",
                   description: "The name of the Node")
        }

    internal init(config: Config, framework: UIFramework) {
        if framework.isSwiftUI {
            name = "\(Config.symbolForSwiftUI) Node"
            stencils = ["Analytics", "Builder-SwiftUI", "Context", "Flow", "ViewController-SwiftUI", "Worker"]
            filenames = [
                "Builder-SwiftUI": "Builder",
                "ViewController-SwiftUI": "ViewController",
                "Worker": "ViewStateWorker"
            ]
        } else if framework.isUIKit {
            name = "Node"
            stencils = ["Analytics", "Builder", "Context", "Flow", "ViewController", "Worker"]
            filenames = ["Worker": "ViewStateWorker"]
        } else {
            name = ""
            stencils = []
            filenames = [:]
        }
        context = NodeContext(
            fileHeader: config.fileHeader,
            nodeName: config.variable("productName"),
            workerName: "\(config.variable("productName"))ViewState",
            builderImports: config.imports(for: .diGraph),
            contextImports: config.imports(for: .nodes),
            flowImports: config.imports(for: .nodes),
            viewControllerImports: config.imports(for: .viewController(framework)),
            workerImports: config.imports(for: .nodes),
            dependencies: config.dependencies,
            flowProperties: config.flowProperties,
            viewControllerType: framework.viewControllerType,
            viewControllableType: config.viewControllableType,
            viewControllableFlowType: config.viewControllableFlowType,
            viewControllerSuperParameters: framework.viewControllerSuperParameters,
            viewControllerProperties: framework.viewControllerProperties,
            viewControllerMethods: framework.viewControllerMethods,
            viewControllerUpdateComment: config.viewControllerUpdateComment,
            viewStatePublisher: config.viewStatePublisher,
            viewStateOperators: config.viewStateOperators,
            publisherType: config.publisherType,
            publisherFailureType: config.publisherFailureType,
            cancellableType: config.cancellableType
        )
    }
}
