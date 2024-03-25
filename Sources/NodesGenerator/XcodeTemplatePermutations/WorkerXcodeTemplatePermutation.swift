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
        let workerTests: StencilTemplate = .workerTests
        stencils = [worker] + (config.isTestTemplatesGenerationEnabled ? [workerTests] : [])
        stencilContext = WorkerStencilContext(
            fileHeader: config.fileHeader,
            workerName: XcodeTemplateConstants.variable(XcodeTemplateConstants.productName),
            workerImports: worker.imports(with: config),
            workerTestsImports: [],
            workerGenericTypes: config.workerGenericTypes,
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled,
            isNimbleEnabled: config.isNimbleEnabled
        )
    }
}
