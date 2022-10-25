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
            stencils = ["Analytics", "Builder-SwiftUI", "Context", "Flow", "ViewController-SwiftUI", "ViewState"]
            filenames = [
                "Builder-SwiftUI": "Builder",
                "ViewController-SwiftUI": "ViewController"
            ]
        } else {
            name = "Node"
            stencils = ["Analytics", "Builder", "Context", "Flow", "ViewController", "ViewState"]
            filenames = [:]
        }
        context = NodeContext(
            fileHeader: config.fileHeader,
            nodeName: config.variable("productName"),
            builderImports: config.imports(for: .diGraph),
            contextImports: config.imports(for: .nodes),
            flowImports: config.imports(for: .nodes),
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
            cancellableType: config.cancellableType
        )
    }
}
