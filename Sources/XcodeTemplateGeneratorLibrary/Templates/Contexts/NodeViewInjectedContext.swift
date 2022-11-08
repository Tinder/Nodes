//
//  NodeViewInjectedContext.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 5/4/21.
//

public struct NodeViewInjectedContext: Context {

    private let fileHeader: String
    private let nodeName: String
    private let workerName: String
    private let builderImports: [String]
    private let contextImports: [String]
    private let flowImports: [String]
    private let workerImports: [String]
    private let dependencies: [[String: Any]]
    private let flowProperties: [[String: Any]]
    private let viewControllableType: String
    private let viewControllableFlowType: String
    private let cancellableType: String

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "node_name": nodeName,
            "worker_name": workerName,
            "owns_view": false,
            "root_node": false,
            "builder_imports": builderImports,
            "context_imports": contextImports,
            "flow_imports": flowImports,
            "worker_imports": workerImports,
            "dependencies": dependencies,
            "flow_properties": flowProperties,
            "view_controllable_type": viewControllableType,
            "view_controllable_flow_type": viewControllableFlowType,
            "cancellable_type": cancellableType
        ]
    }

    public init(
        fileHeader: String,
        nodeName: String,
        workerName: String,
        builderImports: Set<String>,
        contextImports: Set<String>,
        flowImports: Set<String>,
        workerImports: Set<String>,
        dependencies: [XcodeTemplates.Variable],
        flowProperties: [XcodeTemplates.Variable],
        viewControllableType: String,
        viewControllableFlowType: String,
        cancellableType: String
    ) {
        self.fileHeader = fileHeader
        self.nodeName = nodeName
        self.workerName = workerName
        self.builderImports = builderImports.sortedImports()
        self.contextImports = contextImports.sortedImports()
        self.flowImports = flowImports.sortedImports()
        self.workerImports = workerImports.sortedImports()
        self.dependencies = dependencies.map(\.dictionary)
        self.flowProperties = flowProperties.map(\.dictionary)
        self.viewControllableType = viewControllableType
        self.viewControllableFlowType = viewControllableFlowType
        self.cancellableType = cancellableType
    }
}
