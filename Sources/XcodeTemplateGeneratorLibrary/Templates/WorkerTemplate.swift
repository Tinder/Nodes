//
//  WorkerTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

internal struct WorkerTemplate: XcodeTemplate {

    internal typealias Config = XcodeTemplates.Config

    internal let name: String = "Worker"
    internal let stencils: [String] = ["Worker"]
    internal let context: Context

    internal let propertyList: PropertyList =
        .init(description: "The source file implementing a Worker.",
              sortOrder: 7) {
            Option(identifier: "productName",
                   name: "Worker name:",
                   description: "The name of the Worker")
            Option(identifier: "nodeName",
                   name: "Node name:",
                   description: "The name of the Node")
        }

    internal init(config: Config) {
        context = WorkerContext(
            fileHeader: config.fileHeader,
            nodeName: config.variable("nodeName"),
            workerName: config.variable("productName"),
            workerImports: config.imports(for: .worker),
            cancellableType: config.cancellableType
        )
    }
}
