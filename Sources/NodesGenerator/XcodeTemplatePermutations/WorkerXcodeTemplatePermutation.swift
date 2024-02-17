//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

internal struct WorkerXcodeTemplatePermutation: XcodeTemplatePermutation {

    internal let name: String
    internal let stencils: [StencilTemplate]
    internal let stencilContext: StencilContext

    internal init(name: String, config: Config) {
        self.name = name
        let worker: StencilTemplate = .worker
        stencils = [worker]
        stencilContext = WorkerStencilContext(
            fileHeader: config.fileHeader,
            workerName: XcodeTemplateConstants.variable(XcodeTemplateConstants.productName),
            workerImports: worker.imports(config: config),
            workerGenericTypes: config.workerGenericTypes,
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled
        )
    }
}
