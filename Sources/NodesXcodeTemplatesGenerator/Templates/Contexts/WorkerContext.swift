//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

public struct WorkerContext: Context {

    private let fileHeader: String
    private let workerName: String
    private let workerImports: [String]
    private let cancellableType: String
    private let isPeripheryCommentEnabled: Bool

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "worker_name": workerName,
            "worker_imports": workerImports,
            "cancellable_type": cancellableType,
            "is_periphery_comment_enabled": isPeripheryCommentEnabled
        ]
    }

    public init(
        fileHeader: String,
        workerName: String,
        workerImports: Set<String>,
        cancellableType: String,
        isPeripheryCommentEnabled: Bool
    ) {
        self.fileHeader = fileHeader
        self.workerName = workerName
        self.workerImports = workerImports.sortedImports()
        self.cancellableType = cancellableType
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
    }
}
