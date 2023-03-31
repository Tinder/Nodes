//
//  WorkerContext.swift
//  NodesXcodeTemplatesGenerator
//
//  Created by Christopher Fuller on 5/4/21.
//

public struct WorkerContext: Context {

    private let fileHeader: String
    private let workerName: String
    private let workerImports: [String]
    private let cancellableType: String

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "worker_name": workerName,
            "worker_imports": workerImports,
            "cancellable_type": cancellableType
        ]
    }

    public init(
        fileHeader: String,
        workerName: String,
        workerImports: Set<String>,
        cancellableType: String
    ) {
        self.fileHeader = fileHeader
        self.workerName = workerName
        self.workerImports = workerImports.sortedImports()
        self.cancellableType = cancellableType
    }
}
