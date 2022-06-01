//
//  NodeWithoutViewStateTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

internal struct NodeWithoutViewStateTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String
    internal let type: String = "Node"
    internal let stencils: [String]
    internal let filenames: [String: String]
    internal let context: Context

    internal let propertyList: PropertyList =
        .init(description: "The source files implementing a Node.",
              sortOrder: 2) {
            Option(identifier: "productName",
                   name: "Node name:",
                   description: "The name of the Node")
        }

    internal init(config: Config, swiftUI: Bool = false) {
        if swiftUI {
            name = "\(Config.symbolForSwiftUI) Node (without view state)"
            stencils = ["Analytics", "Builder-SwiftUI", "Context", "Flow", "ViewController-SwiftUI", "Worker"]
            filenames = [
                "Builder-SwiftUI": "Builder",
                "ViewController-SwiftUI": "ViewController"
            ]
        } else {
            name = "Node (without view state)"
            stencils = ["Analytics", "Builder", "Context", "Flow", "ViewController", "Worker"]
            filenames = [:]
        }
        context = NodeWithoutViewStateContext(
            fileHeader: config.fileHeader,
            nodeName: config.variable("productName"),
            workerName: config.variable("productName"),
            builderImports: config.imports(for: .diGraph),
            contextImports: config.imports(for: .nodes),
            flowImports: config.imports(for: .nodes),
            viewControllerImports: config.imports(for: .viewController(viewState: false, swiftUI: swiftUI)),
            workerImports: config.imports(for: .nodes),
            dependencies: config.dependencies,
            flowProperties: config.flowProperties,
            viewControllerType: config.viewControllerType,
            viewControllableType: config.viewControllableType,
            viewControllableFlowType: config.viewControllableFlowType,
            viewControllerAvailabilityAttribute: config.viewControllerAvailabilityAttribute(swiftUI: swiftUI),
            viewControllerSuperParameters: config.viewControllerSuperParameters,
            viewControllerProperties: config.viewControllerProperties(swiftUI: swiftUI),
            viewControllerMethods: config.viewControllerMethods(for: .withoutViewState(swiftUI: swiftUI)),
            cancellableType: config.cancellableType
        )
    }
}
