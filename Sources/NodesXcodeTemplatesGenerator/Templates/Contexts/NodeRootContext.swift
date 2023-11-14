//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

public struct NodeRootContext: Context {

    private let fileHeader: String
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
    private let viewControllableType: String
    private let viewControllableFlowType: String
    private let viewControllerType: String
    private let viewControllerSuperParameters: String
    private let viewControllerProperties: String
    private let viewControllerMethods: String
    private let viewControllableMockContents: String
    private let viewControllerSubscriptionsProperty: String
    private let viewControllerUpdateComment: String
    private let viewStateEmptyFactory: String
    private let viewStateOperators: String
    private let viewStatePropertyComment: String
    private let viewStatePropertyName: String
    private let viewStateTransform: String
    private let publisherType: String
    private let publisherFailureType: String
    private let contextGenericTypes: [String]
    private let workerGenericTypes: [String]
    private let isPeripheryCommentEnabled: Bool
    private let isNimbleEnabled: Bool

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "node_name": "Root",
            "owns_view": true,
            "root_node": true,
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
            "view_controllable_type": viewControllableType,
            "view_controllable_flow_type": viewControllableFlowType,
            "view_controller_type": viewControllerType,
            "view_controller_super_parameters": viewControllerSuperParameters,
            "view_controller_properties": viewControllerProperties,
            "view_controller_methods": viewControllerMethods,
            "view_controllable_mock_contents": viewControllableMockContents,
            "view_controller_subscriptions_property": viewControllerSubscriptionsProperty,
            "view_controller_update_comment": viewControllerUpdateComment,
            "view_state_empty_factory": viewStateEmptyFactory,
            "view_state_operators": viewStateOperators,
            "view_state_property_comment": viewStatePropertyComment,
            "view_state_property_name": viewStatePropertyName,
            "view_state_transform": viewStateTransform,
            "publisher_type": publisherType,
            "publisher_failure_type": publisherFailureType,
            "context_generic_types": contextGenericTypes,
            "worker_generic_types": workerGenericTypes,
            "is_periphery_comment_enabled": isPeripheryCommentEnabled,
            "is_nimble_enabled": isNimbleEnabled
        ]
    }

    public init(
        fileHeader: String,
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
        viewControllableType: String,
        viewControllableFlowType: String,
        viewControllerType: String,
        viewControllerSuperParameters: String,
        viewControllerProperties: String,
        viewControllerMethods: String,
        viewControllableMockContents: String,
        viewControllerSubscriptionsProperty: String,
        viewControllerUpdateComment: String,
        viewStateEmptyFactory: String,
        viewStateOperators: String,
        viewStatePropertyComment: String,
        viewStatePropertyName: String,
        viewStateTransform: String,
        publisherType: String,
        publisherFailureType: String,
        contextGenericTypes: [String],
        workerGenericTypes: [String],
        isPeripheryCommentEnabled: Bool,
        isNimbleEnabled: Bool
    ) {
        self.fileHeader = fileHeader
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
        self.viewControllableType = viewControllableType
        self.viewControllableFlowType = viewControllableFlowType
        self.viewControllerType = viewControllerType
        self.viewControllerSuperParameters = viewControllerSuperParameters
        self.viewControllerProperties = viewControllerProperties
        self.viewControllerMethods = viewControllerMethods
        self.viewControllableMockContents = viewControllableMockContents
        self.viewControllerSubscriptionsProperty = viewControllerSubscriptionsProperty
        self.viewControllerUpdateComment = viewControllerUpdateComment
        self.viewStateEmptyFactory = viewStateEmptyFactory
        self.viewStateOperators = viewStateOperators
        self.viewStatePropertyComment = viewStatePropertyComment
        self.viewStatePropertyName = viewStatePropertyName
        self.viewStateTransform = viewStateTransform
        self.publisherType = publisherType
        self.publisherFailureType = publisherFailureType
        self.contextGenericTypes = contextGenericTypes
        self.workerGenericTypes = workerGenericTypes
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
        self.isNimbleEnabled = isNimbleEnabled
    }
}
