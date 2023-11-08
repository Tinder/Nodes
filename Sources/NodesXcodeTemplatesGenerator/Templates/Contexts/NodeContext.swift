//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

public struct NodeContext: Context {

    private let fileHeader: String
    private let nodeName: String
    private let analyticsImports: [String]
    private let builderImports: [String]
    private let contextImports: [String]
    private let flowImports: [String]
    private let stateImports: [String]
    private let viewControllerImports: [String]
    private let viewStateImports: [String]
    private let testImports: [String]
    private let dependencies: [[String: Any]]
    private let analyticsProperties: [[String: Any]]
    private let flowProperties: [[String: Any]]
    private let viewControllerType: String
    private let viewControllableType: String
    private let viewControllableFlowType: String
    private let viewControllerSubscriptionsProperty: String
    private let viewControllerSuperParameters: String
    private let viewControllerProperties: String
    private let viewControllerMethods: String
    private let viewControllableMockContents: String
    private let viewControllerUpdateComment: String
    private let viewStateOperators: String
    private let publisherType: String
    private let publisherFailureType: String
    private let contextGenericTypes: [String]
    private let workerGenericTypes: [String]
    private let isPeripheryCommentEnabled: Bool

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "node_name": nodeName,
            "owns_view": true,
            "root_node": false,
            "analytics_imports": analyticsImports,
            "builder_imports": builderImports,
            "context_imports": contextImports,
            "flow_imports": flowImports,
            "state_imports": stateImports,
            "view_controller_imports": viewControllerImports,
            "view_state_imports": viewStateImports,
            "test_imports": testImports,
            "dependencies": dependencies,
            "analytics_properties": analyticsProperties,
            "flow_properties": flowProperties,
            "view_controller_type": viewControllerType,
            "view_controllable_type": viewControllableType,
            "view_controllable_flow_type": viewControllableFlowType,
            "view_controller_subscriptions_property": viewControllerSubscriptionsProperty,
            "view_controller_super_parameters": viewControllerSuperParameters,
            "view_controller_properties": viewControllerProperties,
            "view_controller_methods": viewControllerMethods,
            "view_controllable_mock_contents": viewControllableMockContents,
            "view_controller_update_comment": viewControllerUpdateComment,
            "view_state_operators": viewStateOperators,
            "publisher_type": publisherType,
            "publisher_failure_type": publisherFailureType,
            "context_generic_types": contextGenericTypes,
            "worker_generic_types": workerGenericTypes,
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
        viewControllerImports: Set<String>,
        viewStateImports: Set<String>,
        testImports: Set<String>,
        dependencies: [XcodeTemplates.Variable],
        analyticsProperties: [XcodeTemplates.Variable],
        flowProperties: [XcodeTemplates.Variable],
        viewControllerType: String,
        viewControllableType: String,
        viewControllableFlowType: String,
        viewControllerSubscriptionsProperty: String,
        viewControllerSuperParameters: String,
        viewControllerProperties: String,
        viewControllerMethods: String,
        viewControllableMockContents: String,
        viewControllerUpdateComment: String,
        viewStateOperators: String,
        publisherType: String,
        publisherFailureType: String,
        contextGenericTypes: [String],
        workerGenericTypes: [String],
        isPeripheryCommentEnabled: Bool
    ) {
        self.fileHeader = fileHeader
        self.nodeName = nodeName
        self.analyticsImports = analyticsImports.sortedImports()
        self.builderImports = builderImports.sortedImports()
        self.contextImports = contextImports.sortedImports()
        self.flowImports = flowImports.sortedImports()
        self.stateImports = stateImports.sortedImports()
        self.viewControllerImports = viewControllerImports.sortedImports()
        self.viewStateImports = viewStateImports.sortedImports()
        self.testImports = testImports.sortedImports()
        self.dependencies = dependencies.map(\.dictionary)
        self.analyticsProperties = analyticsProperties.map(\.dictionary)
        self.flowProperties = flowProperties.map(\.dictionary)
        self.viewControllerType = viewControllerType
        self.viewControllableType = viewControllableType
        self.viewControllableFlowType = viewControllableFlowType
        self.viewControllerSubscriptionsProperty = viewControllerSubscriptionsProperty
        self.viewControllerSuperParameters = viewControllerSuperParameters
        self.viewControllerProperties = viewControllerProperties
        self.viewControllerMethods = viewControllerMethods
        self.viewControllableMockContents = viewControllableMockContents
        self.viewControllerUpdateComment = viewControllerUpdateComment
        self.viewStateOperators = viewStateOperators
        self.publisherType = publisherType
        self.publisherFailureType = publisherFailureType
        self.contextGenericTypes = contextGenericTypes
        self.workerGenericTypes = workerGenericTypes
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
    }
}
