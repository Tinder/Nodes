//
//  WorkerContext.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 5/4/21.
//

public struct WorkerContext: Context {

    private let fileHeader: String
    private let nodeName: String
    private let workerName: String
    private let workerImports: [String]
    private let cancellableType: String

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "node_name": nodeName,
            "worker_name": workerName,
            "worker_imports": workerImports,
            "cancellable_type": cancellableType
        ]
    }

    public init(
        fileHeader: String,
        nodeName: String,
        workerName: String,
        workerImports: Set<String>,
        cancellableType: String
    ) {
        self.fileHeader = fileHeader
        self.nodeName = nodeName
        self.workerName = workerName
        self.workerImports = workerImports.sortedImports()
        self.cancellableType = cancellableType
    }
}
