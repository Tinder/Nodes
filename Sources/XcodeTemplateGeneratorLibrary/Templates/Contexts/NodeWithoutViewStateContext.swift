//
//  NodeWithoutViewStateContext.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 5/4/21.
//

public struct NodeWithoutViewStateContext: Context {

    private let fileHeader: String
    private let nodeName: String
    private let workerName: String
    private let builderImports: [String]
    private let contextImports: [String]
    private let flowImports: [String]
    private let viewControllerImports: [String]
    private let workerImports: [String]
    private let dependencies: [[String: Any]]
    private let flowProperties: [[String: Any]]
    private let viewControllerType: String
    private let viewControllableType: String
    private let viewControllableFlowType: String
    private let viewControllerSuperParameters: String
    private let viewControllerProperties: String
    private let viewControllerMethods: String
    private let cancellableType: String

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "node_name": nodeName,
            "worker_name": workerName,
            "owns_view": true,
            "root_node": false,
            "builder_imports": builderImports,
            "context_imports": contextImports,
            "flow_imports": flowImports,
            "view_controller_imports": viewControllerImports,
            "worker_imports": workerImports,
            "dependencies": dependencies,
            "flow_properties": flowProperties,
            "view_controller_type": viewControllerType,
            "view_controllable_type": viewControllableType,
            "view_controllable_flow_type": viewControllableFlowType,
            "view_controller_super_parameters": viewControllerSuperParameters,
            "view_controller_properties": viewControllerProperties,
            "view_controller_methods": viewControllerMethods,
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
        viewControllerImports: Set<String>,
        workerImports: Set<String>,
        dependencies: [XcodeTemplates.Variable],
        flowProperties: [XcodeTemplates.Variable],
        viewControllerType: String,
        viewControllableType: String,
        viewControllableFlowType: String,
        viewControllerSuperParameters: String,
        viewControllerProperties: String,
        viewControllerMethods: String,
        cancellableType: String
    ) {
        self.fileHeader = fileHeader
        self.nodeName = nodeName
        self.workerName = workerName
        self.builderImports = builderImports.sortedImports()
        self.contextImports = contextImports.sortedImports()
        self.flowImports = flowImports.sortedImports()
        self.viewControllerImports = viewControllerImports.sortedImports()
        self.workerImports = workerImports.sortedImports()
        self.dependencies = dependencies.map(\.dictionary)
        self.flowProperties = flowProperties.map(\.dictionary)
        self.viewControllerType = viewControllerType
        self.viewControllableType = viewControllableType
        self.viewControllableFlowType = viewControllableFlowType
        self.viewControllerSuperParameters = viewControllerSuperParameters
        self.viewControllerProperties = viewControllerProperties
        self.viewControllerMethods = viewControllerMethods
        self.cancellableType = cancellableType
    }
}
