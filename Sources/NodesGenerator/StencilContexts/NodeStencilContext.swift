//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

// swiftlint:disable:next type_body_length
public struct NodeStencilContext: StencilContext {

    private let fileHeader: String
    private let nodeName: String
    private let pluginName: String
    private let pluginListName: String
    private let analyticsImports: [String]
    private let builderImports: [String]
    private let contextImports: [String]
    private let flowImports: [String]
    private let pluginImports: [String]
    private let stateImports: [String]
    private let viewControllerImports: [String]
    private let viewStateImports: [String]
    private let analyticsTestsImports: [String]
    private let contextTestsImports: [String]
    private let flowTestsImports: [String]
    private let pluginTestsImports: [String]
    private let viewControllerTestsImports: [String]
    private let viewStateFactoryTestsImports: [String]
    private let dependencies: [[String: Any]]
    private let componentDependencies: String
    private let analyticsProperties: [[String: Any]]
    private let flowProperties: [[String: Any]]
    private let viewControllableFlowType: String
    private let viewControllableType: String
    private let viewControllableMockContents: String
    private let viewControllerType: String
    private let viewControllerSuperParameters: String
    private let viewControllerProperties: String
    private let viewControllerMethods: String
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
            "node_name": nodeName,
            "plugin_name": pluginName,
            "plugin_list_name": pluginListName,
            "owns_view": true,
            "analytics_imports": analyticsImports,
            "builder_imports": builderImports,
            "context_imports": contextImports,
            "flow_imports": flowImports,
            "plugin_imports": pluginImports,
            "state_imports": stateImports,
            "view_controller_imports": viewControllerImports,
            "view_state_imports": viewStateImports,
            "analytics_tests_imports": analyticsTestsImports,
            "context_tests_imports": contextTestsImports,
            "flow_tests_imports": flowTestsImports,
            "plugin_tests_imports": pluginTestsImports,
            "view_controller_tests_imports": viewControllerTestsImports,
            "view_state_factory_tests_imports": viewStateFactoryTestsImports,
            "dependencies": dependencies,
            "component_dependencies": componentDependencies,
            "analytics_properties": analyticsProperties,
            "flow_properties": flowProperties,
            "view_controllable_flow_type": viewControllableFlowType,
            "view_controllable_type": viewControllableType,
            "view_controllable_mock_contents": viewControllableMockContents,
            "view_controller_type": viewControllerType,
            "view_controller_super_parameters": viewControllerSuperParameters,
            "view_controller_properties": viewControllerProperties,
            "view_controller_methods": viewControllerMethods,
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
        fileHeader: String,
        nodeName: String,
        pluginName: String,
        pluginListName: String,
        analyticsImports: Set<String>,
        builderImports: Set<String>,
        contextImports: Set<String>,
        flowImports: Set<String>,
        pluginImports: Set<String>,
        stateImports: Set<String>,
        viewControllerImports: Set<String>,
        viewStateImports: Set<String>,
        analyticsTestsImports: Set<String>,
        contextTestsImports: Set<String>,
        flowTestsImports: Set<String>,
        pluginTestsImports: Set<String>,
        viewControllerTestsImports: Set<String>,
        viewStateFactoryTestsImports: Set<String>,
        dependencies: [Config.Variable],
        componentDependencies: String = "",
        analyticsProperties: [Config.Variable],
        flowProperties: [Config.Variable],
        viewControllableFlowType: String,
        viewControllableType: String,
        viewControllableMockContents: String,
        viewControllerType: String,
        viewControllerSuperParameters: String,
        viewControllerProperties: String,
        viewControllerMethods: String,
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
    ) throws {
        self = try Self(
            strict: true,
            fileHeader: fileHeader,
            nodeName: nodeName,
            pluginName: pluginName,
            pluginListName: pluginListName,
            analyticsImports: analyticsImports,
            builderImports: builderImports,
            contextImports: contextImports,
            flowImports: flowImports,
            pluginImports: pluginImports,
            stateImports: stateImports,
            viewControllerImports: viewControllerImports,
            viewStateImports: viewStateImports,
            analyticsTestsImports: analyticsTestsImports,
            contextTestsImports: contextTestsImports,
            flowTestsImports: flowTestsImports,
            pluginTestsImports: pluginTestsImports,
            viewControllerTestsImports: viewControllerTestsImports,
            viewStateFactoryTestsImports: viewStateFactoryTestsImports,
            dependencies: dependencies,
            componentDependencies: componentDependencies,
            analyticsProperties: analyticsProperties,
            flowProperties: flowProperties,
            viewControllableFlowType: viewControllableFlowType,
            viewControllableType: viewControllableType,
            viewControllableMockContents: viewControllableMockContents,
            viewControllerType: viewControllerType,
            viewControllerSuperParameters: viewControllerSuperParameters,
            viewControllerProperties: viewControllerProperties,
            viewControllerMethods: viewControllerMethods,
            viewControllerSubscriptionsProperty: viewControllerSubscriptionsProperty,
            viewControllerUpdateComment: viewControllerUpdateComment,
            viewStateEmptyFactory: viewStateEmptyFactory,
            viewStateOperators: viewStateOperators,
            viewStatePropertyComment: viewStatePropertyComment,
            viewStatePropertyName: viewStatePropertyName,
            viewStateTransform: viewStateTransform,
            publisherType: publisherType,
            publisherFailureType: publisherFailureType,
            contextGenericTypes: contextGenericTypes,
            workerGenericTypes: workerGenericTypes,
            isPreviewProviderEnabled: isPreviewProviderEnabled,
            isPeripheryCommentEnabled: isPeripheryCommentEnabled,
            isNimbleEnabled: isNimbleEnabled
        )
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
        analyticsTestsImports: Set<String>,
        contextTestsImports: Set<String>,
        flowTestsImports: Set<String>,
        viewControllerTestsImports: Set<String>,
        viewStateFactoryTestsImports: Set<String>,
        dependencies: [Config.Variable],
        analyticsProperties: [Config.Variable],
        flowProperties: [Config.Variable],
        viewControllableFlowType: String,
        viewControllableType: String,
        viewControllableMockContents: String,
        viewControllerType: String,
        viewControllerSuperParameters: String,
        viewControllerProperties: String,
        viewControllerMethods: String,
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
    ) throws {
        guard !preset.isViewInjected
        else { throw StencilContextError.invalidPreset(preset.nodeName) }
        self = try Self(
            strict: false,
            fileHeader: fileHeader,
            nodeName: preset.nodeName,
            pluginName: "",
            pluginListName: "",
            analyticsImports: analyticsImports,
            builderImports: builderImports,
            contextImports: contextImports,
            flowImports: flowImports,
            pluginImports: [],
            stateImports: stateImports,
            viewControllerImports: viewControllerImports,
            viewStateImports: viewStateImports,
            analyticsTestsImports: analyticsTestsImports,
            contextTestsImports: contextTestsImports,
            flowTestsImports: flowTestsImports,
            pluginTestsImports: [],
            viewControllerTestsImports: viewControllerTestsImports,
            viewStateFactoryTestsImports: viewStateFactoryTestsImports,
            dependencies: dependencies,
            componentDependencies: preset.componentDependencies,
            analyticsProperties: analyticsProperties,
            flowProperties: flowProperties,
            viewControllableFlowType: viewControllableFlowType,
            viewControllableType: viewControllableType,
            viewControllableMockContents: viewControllableMockContents,
            viewControllerType: viewControllerType,
            viewControllerSuperParameters: viewControllerSuperParameters,
            viewControllerProperties: viewControllerProperties,
            viewControllerMethods: viewControllerMethods,
            viewControllerSubscriptionsProperty: viewControllerSubscriptionsProperty,
            viewControllerUpdateComment: viewControllerUpdateComment,
            viewStateEmptyFactory: viewStateEmptyFactory,
            viewStateOperators: viewStateOperators,
            viewStatePropertyComment: viewStatePropertyComment,
            viewStatePropertyName: viewStatePropertyName,
            viewStateTransform: viewStateTransform,
            publisherType: publisherType,
            publisherFailureType: publisherFailureType,
            contextGenericTypes: contextGenericTypes,
            workerGenericTypes: workerGenericTypes,
            isPreviewProviderEnabled: isPreviewProviderEnabled,
            isPeripheryCommentEnabled: isPeripheryCommentEnabled,
            isNimbleEnabled: isNimbleEnabled
        )
    }

    private init(
        strict: Bool,
        fileHeader: String,
        nodeName: String,
        pluginName: String,
        pluginListName: String,
        analyticsImports: Set<String>,
        builderImports: Set<String>,
        contextImports: Set<String>,
        flowImports: Set<String>,
        pluginImports: Set<String>,
        stateImports: Set<String>,
        viewControllerImports: Set<String>,
        viewStateImports: Set<String>,
        analyticsTestsImports: Set<String>,
        contextTestsImports: Set<String>,
        flowTestsImports: Set<String>,
        pluginTestsImports: Set<String>,
        viewControllerTestsImports: Set<String>,
        viewStateFactoryTestsImports: Set<String>,
        dependencies: [Config.Variable],
        componentDependencies: String,
        analyticsProperties: [Config.Variable],
        flowProperties: [Config.Variable],
        viewControllableFlowType: String,
        viewControllableType: String,
        viewControllableMockContents: String,
        viewControllerType: String,
        viewControllerSuperParameters: String,
        viewControllerProperties: String,
        viewControllerMethods: String,
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
    ) throws {
        guard !strict || Preset(rawValue: nodeName) == nil
        else { throw StencilContextError.reservedNodeName(nodeName) }
        self.fileHeader = fileHeader
        self.nodeName = nodeName
        self.pluginName = pluginName
        self.pluginListName = pluginListName
        self.analyticsImports = analyticsImports.sortedImports()
        self.builderImports = builderImports.sortedImports()
        self.contextImports = contextImports.sortedImports()
        self.flowImports = flowImports.sortedImports()
        self.pluginImports = pluginImports.sortedImports()
        self.stateImports = stateImports.sortedImports()
        self.viewControllerImports = viewControllerImports.sortedImports()
        self.viewStateImports = viewStateImports.sortedImports()
        self.analyticsTestsImports = analyticsTestsImports.sortedImports()
        self.contextTestsImports = contextTestsImports.sortedImports()
        self.flowTestsImports = flowTestsImports.sortedImports()
        self.pluginTestsImports = pluginTestsImports.sortedImports()
        self.viewControllerTestsImports = viewControllerTestsImports.sortedImports()
        self.viewStateFactoryTestsImports = viewStateFactoryTestsImports.sortedImports()
        self.dependencies = dependencies.map(\.dictionary)
        self.componentDependencies = componentDependencies
        self.analyticsProperties = analyticsProperties.map(\.dictionary)
        self.flowProperties = flowProperties.map(\.dictionary)
        self.viewControllableFlowType = viewControllableFlowType
        self.viewControllableType = viewControllableType
        self.viewControllableMockContents = viewControllableMockContents
        self.viewControllerType = viewControllerType
        self.viewControllerSuperParameters = viewControllerSuperParameters
        self.viewControllerProperties = viewControllerProperties
        self.viewControllerMethods = viewControllerMethods
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
