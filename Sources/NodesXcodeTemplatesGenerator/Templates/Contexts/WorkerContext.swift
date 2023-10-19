//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

public struct WorkerContext: Context {

    private let fileHeader: String
    private let workerName: String
    private let workerImports: [String]
    private let cancellableType: String
    private let includePeripheryIgnores: Bool

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "worker_name": workerName,
            "worker_imports": workerImports,
            "cancellable_type": cancellableType,
            "include_periphery_ignores": includePeripheryIgnores
        ]
    }

    public init(
        fileHeader: String,
        workerName: String,
        workerImports: Set<String>,
        cancellableType: String,
        includePeripheryIgnores: Bool
    ) {
        self.fileHeader = fileHeader
        self.workerName = workerName
        self.workerImports = workerImports.sortedImports()
        self.cancellableType = cancellableType
        self.includePeripheryIgnores = includePeripheryIgnores
    }
}
