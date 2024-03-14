//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

public struct WorkerStencilContext: StencilContext {

    private let fileHeader: String
    private let workerName: String
    private let workerImports: [String]
    private let workerTestsImports: [String]
    private let workerGenericTypes: [String]
    private let isPeripheryCommentEnabled: Bool
    private let isNimbleEnabled: Bool

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "worker_name": workerName,
            "worker_imports": workerImports,
            "worker_tests_imports": workerTestsImports,
            "worker_generic_types": workerGenericTypes,
            "is_periphery_comment_enabled": isPeripheryCommentEnabled,
            "is_nimble_enabled": isNimbleEnabled
        ]
    }

    public init(
        fileHeader: String,
        workerName: String,
        workerImports: Set<String>,
        workerTestsImports: Set<String>,
        workerGenericTypes: [String],
        isPeripheryCommentEnabled: Bool,
        isNimbleEnabled: Bool
    ) {
        self.fileHeader = fileHeader
        self.workerName = workerName
        self.workerImports = workerImports.sortedImports()
        self.workerTestsImports = workerTestsImports.sortedImports()
        self.workerGenericTypes = workerGenericTypes
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
        self.isNimbleEnabled = isNimbleEnabled
    }
}
