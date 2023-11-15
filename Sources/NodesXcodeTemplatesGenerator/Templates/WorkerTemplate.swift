//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal struct WorkerTemplate: XcodeTemplate {

    internal let name: String = "Worker"
    internal let stencils: [StencilTemplate]
    internal let context: Context

    internal let propertyList: PropertyList =
        .init(description: "The source file implementing a Worker.",
              sortOrder: 9) {
            Option(identifier: "productName",
                   name: "Worker name:",
                   description: "The name of the Worker")
        }

    internal init(config: Config) {
        let worker: StencilTemplate = .worker
        stencils = [worker]
        context = WorkerContext(
            fileHeader: config.fileHeader,
            workerName: config.variable("productName"),
            workerImports: worker.imports(config: config),
            workerGenericTypes: config.workerGenericTypes,
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled
        )
    }
}
