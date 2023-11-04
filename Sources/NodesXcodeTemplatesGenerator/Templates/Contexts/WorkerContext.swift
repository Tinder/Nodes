//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

public struct WorkerContext: Context {

    private let fileHeader: String
    private let workerName: String
    private let workerImports: [String]
    private let workerGenericTypes: [String]

    private let isPeripheryCommentEnabled: Bool

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "worker_name": workerName,
            "worker_imports": workerImports,
            "worker_generic_types": workerGenericTypes,
            "is_periphery_comment_enabled": isPeripheryCommentEnabled
        ]
    }

    public init(
        fileHeader: String,
        workerName: String,
        workerImports: Set<String>,
        workerGenericTypes: [String],
        isPeripheryCommentEnabled: Bool
    ) {
        self.fileHeader = fileHeader
        self.workerName = workerName
        self.workerImports = workerImports.sortedImports()
        self.workerGenericTypes = workerGenericTypes
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
    }
}
