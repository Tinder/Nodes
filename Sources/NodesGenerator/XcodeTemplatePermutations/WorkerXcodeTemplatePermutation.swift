//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
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
            fileHeader: XcodeTemplateConstants.fileHeader,
            workerName: XcodeTemplateConstants.variable(XcodeTemplateConstants.productName),
            workerImports: worker.imports(with: config),
            workerTestsImports: workerTests.imports(with: config),
            workerGenericTypes: config.workerGenericTypes,
            isPeripheryCommentEnabled: config.isPeripheryCommentEnabled,
            isNimbleEnabled: config.isNimbleEnabled
        )
    }
}
