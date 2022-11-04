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

    internal init(config: Config, swiftUI: Bool = false) {
        if swiftUI {
            name = "\(Config.symbolForSwiftUI) Node"
            stencils = ["Analytics", "Builder-SwiftUI", "Context", "Flow", "ViewController-SwiftUI", "Worker"]
            filenames = [
                "Builder-SwiftUI": "Builder",
                "ViewController-SwiftUI": "ViewController",
                "Worker": "ViewStateWorker"
            ]
        } else {
            name = "Node"
            stencils = ["Analytics", "Builder", "Context", "Flow", "ViewController", "Worker"]
            filenames = ["Worker": "ViewStateWorker"]
        }
        context = NodeContext(
            fileHeader: config.fileHeader,
            nodeName: config.variable("productName"),
            workerName: "\(config.variable("productName"))ViewState",
            builderImports: config.imports(for: swiftUI ? .builderSwiftUI : .builder),
            contextImports: config.imports(for: .context),
            flowImports: config.imports(for: .flow),
            viewControllerImports: config.imports(for: swiftUI ? .viewControllerSwiftUI : .viewController),
            workerImports: config.imports(for: .worker),
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
            cancellableType: config.cancellableType
        )
    }
}
