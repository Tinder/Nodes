//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

public struct NodeViewInjectedContext: Context {

    private let fileHeader: String
    private let nodeName: String
    private let analyticsImports: [String]
    private let builderImports: [String]
    private let contextImports: [String]
    private let flowImports: [String]
    private let stateImports: [String]
    private let dependencies: [[String: Any]]
    private let analyticsProperties: [[String: Any]]
    private let flowProperties: [[String: Any]]
    private let viewControllableType: String
    private let viewControllableFlowType: String
    private let cancellableType: String
    private let isPeripheryCommentEnabled: Bool

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "node_name": nodeName,
            "owns_view": false,
            "root_node": false,
            "analytics_imports": analyticsImports,
            "builder_imports": builderImports,
            "context_imports": contextImports,
            "flow_imports": flowImports,
            "state_imports": stateImports,
            "dependencies": dependencies,
            "analytics_properties": analyticsProperties,
            "flow_properties": flowProperties,
            "view_controllable_type": viewControllableType,
            "view_controllable_flow_type": viewControllableFlowType,
            "cancellable_type": cancellableType,
            "is_periphery_comment_enabled": isPeripheryCommentEnabled
        ]
    }

    public init(
        fileHeader: String,
        nodeName: String,
        analyticsImports: Set<String>,
        builderImports: Set<String>,
        contextImports: Set<String>,
        flowImports: Set<String>,
        stateImports: Set<String>,
        dependencies: [XcodeTemplates.Variable],
        analyticsProperties: [XcodeTemplates.Variable],
        flowProperties: [XcodeTemplates.Variable],
        viewControllableType: String,
        viewControllableFlowType: String,
        cancellableType: String,
        isPeripheryCommentEnabled: Bool
    ) {
        self.fileHeader = fileHeader
        self.nodeName = nodeName
        self.analyticsImports = analyticsImports.sortedImports()
        self.builderImports = builderImports.sortedImports()
        self.contextImports = contextImports.sortedImports()
        self.flowImports = flowImports.sortedImports()
        self.stateImports = stateImports.sortedImports()
        self.dependencies = dependencies.map(\.dictionary)
        self.analyticsProperties = analyticsProperties.map(\.dictionary)
        self.flowProperties = flowProperties.map(\.dictionary)
        self.viewControllableType = viewControllableType
        self.viewControllableFlowType = viewControllableFlowType
        self.cancellableType = cancellableType
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
    }
}
