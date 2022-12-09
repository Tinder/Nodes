//
//  NodeTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

internal struct NodeTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String
    internal let stencils: [StencilTemplate]
    internal let filenames: [String: String]
    internal let context: Context
    internal let propertyList: PropertyList

    internal init(for kind: UIFramework.Kind, config: Config) throws {
        let uiFramework: UIFramework = try config.uiFramework(for: kind)
        let swiftUI: Bool = uiFramework.kind == .swiftUI
        name = "Node - \(uiFramework.name)"
        stencils = StencilTemplate.nodeStencils(for: .variation(for: uiFramework.kind))
        if swiftUI {
            filenames = [
                "Builder-SwiftUI": "Builder",
                "ViewController-SwiftUI": "ViewController",
                "Worker": "ViewStateWorker"
            ]
        } else {
            filenames = ["Worker": "ViewStateWorker"]
        }
        context = NodeContext(
            fileHeader: config.fileHeader,
            nodeName: config.variable("productName"),
            workerName: "\(config.variable("productName"))ViewState",
            builderImports: config.imports(for: .diGraph),
            contextImports: config.imports(for: .nodes),
            flowImports: config.imports(for: .nodes),
            viewControllerImports: config.imports(for: .viewController(uiFramework)),
            workerImports: config.imports(for: .nodes),
            dependencies: config.dependencies,
            flowProperties: config.flowProperties,
            viewControllerType: uiFramework.viewControllerType,
            viewControllableType: config.viewControllableType,
            viewControllableFlowType: config.viewControllableFlowType,
            viewControllerSuperParameters: uiFramework.viewControllerSuperParameters,
            viewControllerProperties: uiFramework.viewControllerProperties,
            viewControllerMethods: uiFramework.viewControllerMethods,
            viewControllerUpdateComment: config.viewControllerUpdateComment,
            viewStatePublisher: config.viewStatePublisher,
            viewStateOperators: config.viewStateOperators,
            publisherType: config.publisherType,
            publisherFailureType: config.publisherFailureType,
            cancellableType: config.cancellableType
        )
        propertyList = PropertyList(description: "The source files implementing a Node.",
                                    // swiftlint:disable:next force_unwrapping
                                    sortOrder: UIFramework.Kind.allCases.firstIndex(of: kind)! + 1) {
            Option(identifier: "productName",
                   name: "Node name:",
                   description: "The name of the Node")
        }
    }
}
