//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Foundation

public struct NodePresetStencilContext: StencilContext {

    public enum NodePresetStencilContextError: LocalizedError {

        case reservedNodeName(String)

        public var errorDescription: String? {
            switch self {
            case let .reservedNodeName(nodeName):
                return "ERROR: Reserved Node Name (\(nodeName)"
            }
        }
    }

    public enum Preset: String {

        case app = "App"
        case scene = "Scene"
        case window = "Window"
        case root = "Root"

        public var nodeName: String {
            rawValue
        }

        public var ownsView: Bool {
            switch self {
            case .app:
                return false
            case .scene:
                return false
            case .window:
                return true
            case .root:
                return true
            }
        }
    }

    internal let preset: Preset

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
    private let isPreviewProviderEnabled: Bool
    private let isPeripheryCommentEnabled: Bool
    private let isNimbleEnabled: Bool

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "node_name": preset.nodeName,
            "owns_view": preset.ownsView,
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
            "is_preview_provider_enabled": isPreviewProviderEnabled,
            "is_periphery_comment_enabled": isPeripheryCommentEnabled,
            "is_nimble_enabled": isNimbleEnabled
        ]
    }

    public init(
        preset: Preset,
        fileHeader: String,
        analyticsImports: Set<String>,
        builderImports: Set<String>,
        contextImports: Set<String>,
        flowImports: Set<String>,
        stateImports: Set<String>,
        viewControllerImports: Set<String>,
        viewStateImports: Set<String>,
        testImports: Set<String>,
        dependencies: [Config.Variable],
        analyticsProperties: [Config.Variable],
        flowProperties: [Config.Variable],
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
        isPreviewProviderEnabled: Bool,
        isPeripheryCommentEnabled: Bool,
        isNimbleEnabled: Bool
    ) {
        self.preset = preset
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
        self.isPreviewProviderEnabled = isPreviewProviderEnabled
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
        self.isNimbleEnabled = isNimbleEnabled
    }
}
