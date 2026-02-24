//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

// swiftlint:disable file_length

// swiftlint:disable:next type_body_length
public struct NodeStencilContext: StencilContext {

    private let fileHeader: String
    private let nodeName: String
    private let pluginName: String
    private let pluginListName: String
    private let analyticsImports: [String]
    private let analyticsTestsImports: [String]
    private let builderImports: [String]
    private let builderTestsImports: [String]
    private let contextImports: [String]
    private let contextTestsImports: [String]
    private let flowImports: [String]
    private let flowTestsImports: [String]
    private let interfaceImports: [String]
    private let pluginImports: [String]
    private let pluginInterfaceImports: [String]
    private let pluginTestsImports: [String]
    private let stateImports: [String]
    private let viewControllerImports: [String]
    private let viewControllerTestsImports: [String]
    private let viewStateImports: [String]
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
    private let viewControllerMethods: String
    private let viewControllerStaticContent: String
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
    private let storePrefix: String
    private let storePropertyWrapper: String
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
            "analytics_tests_imports": analyticsTestsImports,
            "builder_imports": builderImports,
            "builder_tests_imports": builderTestsImports,
            "context_imports": contextImports,
            "context_tests_imports": contextTestsImports,
            "flow_imports": flowImports,
            "flow_tests_imports": flowTestsImports,
            "interface_imports": interfaceImports,
            "plugin_imports": pluginImports,
            "plugin_interface_imports": pluginInterfaceImports,
            "plugin_tests_imports": pluginTestsImports,
            "state_imports": stateImports,
            "view_controller_imports": viewControllerImports,
            "view_controller_tests_imports": viewControllerTestsImports,
            "view_state_imports": viewStateImports,
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
            "view_controller_methods": viewControllerMethods,
            "view_controller_static_content": viewControllerStaticContent,
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
            "store_prefix": storePrefix,
            "store_property_wrapper": storePropertyWrapper,
            "is_preview_provider_enabled": isPreviewProviderEnabled,
            "is_periphery_comment_enabled": isPeripheryCommentEnabled,
            "is_nimble_enabled": isNimbleEnabled
        ]
    }

    // swiftlint:disable:next function_body_length
    public init(
        fileHeader: String,
        nodeName: String,
        pluginName: String,
        pluginListName: String,
        analyticsImports: Set<String>,
        analyticsTestsImports: Set<String>,
        builderImports: Set<String>,
        builderTestsImports: Set<String>,
        contextImports: Set<String>,
        contextTestsImports: Set<String>,
        flowImports: Set<String>,
        flowTestsImports: Set<String>,
        interfaceImports: Set<String>,
        pluginImports: Set<String>,
        pluginInterfaceImports: Set<String>,
        pluginTestsImports: Set<String>,
        stateImports: Set<String>,
        viewControllerImports: Set<String>,
        viewControllerTestsImports: Set<String>,
        viewStateImports: Set<String>,
        viewStateFactoryTestsImports: Set<String>,
        dependencies: [Config.Variable],
        componentDependencies: String = "", // swiftlint:disable:this function_default_parameter_at_end
        analyticsProperties: [Config.Variable],
        flowProperties: [Config.Variable],
        viewControllableFlowType: String,
        viewControllableType: String,
        viewControllableMockContents: String,
        viewControllerType: String,
        viewControllerSuperParameters: String,
        viewControllerMethods: String,
        viewControllerStaticContent: String,
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
        storePrefix: String,
        storePropertyWrapper: String,
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
            analyticsTestsImports: analyticsTestsImports,
            builderImports: builderImports,
            builderTestsImports: builderTestsImports,
            contextImports: contextImports,
            contextTestsImports: contextTestsImports,
            flowImports: flowImports,
            flowTestsImports: flowTestsImports,
            interfaceImports: interfaceImports,
            pluginImports: pluginImports,
            pluginInterfaceImports: pluginInterfaceImports,
            pluginTestsImports: pluginTestsImports,
            stateImports: stateImports,
            viewControllerImports: viewControllerImports,
            viewControllerTestsImports: viewControllerTestsImports,
            viewStateImports: viewStateImports,
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
            viewControllerMethods: viewControllerMethods,
            viewControllerStaticContent: viewControllerStaticContent,
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
            storePrefix: storePrefix,
            storePropertyWrapper: storePropertyWrapper,
            isPreviewProviderEnabled: isPreviewProviderEnabled,
            isPeripheryCommentEnabled: isPeripheryCommentEnabled,
            isNimbleEnabled: isNimbleEnabled
        )
    }

    // swiftlint:disable:next function_body_length
    public init(
        preset: Preset,
        fileHeader: String,
        analyticsImports: Set<String>,
        analyticsTestsImports: Set<String>,
        builderImports: Set<String>,
        builderTestsImports: Set<String>,
        contextImports: Set<String>,
        contextTestsImports: Set<String>,
        flowImports: Set<String>,
        flowTestsImports: Set<String>,
        interfaceImports: Set<String>,
        stateImports: Set<String>,
        viewControllerImports: Set<String>,
        viewControllerTestsImports: Set<String>,
        viewStateImports: Set<String>,
        viewStateFactoryTestsImports: Set<String>,
        dependencies: [Config.Variable],
        analyticsProperties: [Config.Variable],
        flowProperties: [Config.Variable],
        viewControllableFlowType: String,
        viewControllableType: String,
        viewControllableMockContents: String,
        viewControllerType: String,
        viewControllerSuperParameters: String,
        viewControllerMethods: String,
        viewControllerStaticContent: String,
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
        storePrefix: String,
        storePropertyWrapper: String,
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
            analyticsTestsImports: analyticsTestsImports,
            builderImports: builderImports,
            builderTestsImports: builderTestsImports,
            contextImports: contextImports,
            contextTestsImports: contextTestsImports,
            flowImports: flowImports,
            flowTestsImports: flowTestsImports,
            interfaceImports: interfaceImports,
            pluginImports: [],
            pluginInterfaceImports: [],
            pluginTestsImports: [],
            stateImports: stateImports,
            viewControllerImports: viewControllerImports,
            viewControllerTestsImports: viewControllerTestsImports,
            viewStateImports: viewStateImports,
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
            viewControllerMethods: viewControllerMethods,
            viewControllerStaticContent: viewControllerStaticContent,
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
            storePrefix: storePrefix,
            storePropertyWrapper: storePropertyWrapper,
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
        analyticsTestsImports: Set<String>,
        builderImports: Set<String>,
        builderTestsImports: Set<String>,
        contextImports: Set<String>,
        contextTestsImports: Set<String>,
        flowImports: Set<String>,
        flowTestsImports: Set<String>,
        interfaceImports: Set<String>,
        pluginImports: Set<String>,
        pluginInterfaceImports: Set<String>,
        pluginTestsImports: Set<String>,
        stateImports: Set<String>,
        viewControllerImports: Set<String>,
        viewControllerTestsImports: Set<String>,
        viewStateImports: Set<String>,
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
        viewControllerMethods: String,
        viewControllerStaticContent: String,
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
        storePrefix: String,
        storePropertyWrapper: String,
        isPreviewProviderEnabled: Bool,
        isPeripheryCommentEnabled: Bool,
        isNimbleEnabled: Bool
    ) throws {
        guard !strict || !Preset.isPresetNodeName(nodeName)
        else { throw StencilContextError.reservedNodeName(nodeName) }
        self.fileHeader = fileHeader
        self.nodeName = nodeName
        self.pluginName = pluginName
        self.pluginListName = pluginListName
        self.analyticsImports = analyticsImports.sortedImports()
        self.analyticsTestsImports = analyticsTestsImports.sortedImports()
        self.builderImports = builderImports.sortedImports()
        self.builderTestsImports = builderTestsImports.sortedImports()
        self.contextImports = contextImports.sortedImports()
        self.contextTestsImports = contextTestsImports.sortedImports()
        self.flowImports = flowImports.sortedImports()
        self.flowTestsImports = flowTestsImports.sortedImports()
        self.interfaceImports = interfaceImports.sortedImports()
        self.pluginImports = pluginImports.sortedImports()
        self.pluginInterfaceImports = pluginInterfaceImports.sortedImports()
        self.pluginTestsImports = pluginTestsImports.sortedImports()
        self.stateImports = stateImports.sortedImports()
        self.viewControllerImports = viewControllerImports.sortedImports()
        self.viewControllerTestsImports = viewControllerTestsImports.sortedImports()
        self.viewStateImports = viewStateImports.sortedImports()
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
        self.viewControllerMethods = viewControllerMethods
        self.viewControllerStaticContent = viewControllerStaticContent
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
        self.storePrefix = storePrefix
        self.storePropertyWrapper = storePropertyWrapper
        self.isPreviewProviderEnabled = isPreviewProviderEnabled
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
        self.isNimbleEnabled = isNimbleEnabled
    }
}

// swiftlint:enable file_length
