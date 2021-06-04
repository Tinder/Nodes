//
//  RootNodeTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

internal struct RootNodeTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String
    internal let type: String = "Node"
    internal let stencils: [String]
    internal let filenames: [String: String]
    internal let context: Context

    internal let propertyList: PropertyList =
        .init(description: "The source files implementing a Node.",
              sortOrder: 4) {
            Option(identifier: "productName",
                   name: "Node name:",
                   description: "The name of the Node",
                   default: "Root")
        }

    internal init(config: Config, swiftUI: Bool = false) {
        if swiftUI {
            name = "\(Config.symbolForSwiftUI) Node (for root)"
            stencils = ["Analytics", "Builder-SwiftUI", "Context", "Flow", "ViewController-SwiftUI", "Worker"]
            filenames = [
                "Builder-SwiftUI": "Builder",
                "ViewController-SwiftUI": "ViewController",
                "Worker": "ViewStateWorker"
            ]
        } else {
            name = "Node (for root)"
            stencils = ["Analytics", "Builder", "Context", "Flow", "ViewController", "Worker"]
            filenames = ["Worker": "ViewStateWorker"]
        }
        context = NodeContext(
            fileHeader: config.fileHeader,
            nodeName: config.variable("productName"),
            workerName: "\(config.variable("productName"))ViewState",
            publicNode: false,
            rootNode: true,
            builderImports: config.imports(for: .diGraph),
            contextImports: config.imports(for: .nodes),
            flowImports: config.imports(for: .nodes),
            viewControllerImports: config.imports(for: .viewController(swiftUI: swiftUI)),
            workerImports: config.imports(for: .nodes),
            dependencies: config.dependencies,
            flowProperties: config.flowProperties,
            viewControllerType: config.viewControllerType,
            viewControllableType: config.viewControllableType,
            viewControllableFlowType: config.viewControllableFlowType,
            viewControllerSuperParameters: config.viewControllerSuperParameters,
            viewControllerProperties: config.viewControllerProperties(swiftUI: swiftUI),
            viewControllerMethods: config.viewControllerMethods(for: .root(swiftUI: swiftUI)),
            viewControllerUpdateComment: config.viewControllerUpdateComment,
            viewStatePublisher: config.viewStatePublisher,
            viewStateOperators: config.viewStateOperators,
            publisherType: config.publisherType,
            publisherFailureType: config.publisherFailureType,
            cancellableType: config.cancellableType
        )
    }
}
