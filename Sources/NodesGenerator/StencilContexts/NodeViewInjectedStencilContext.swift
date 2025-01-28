//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

public struct NodeViewInjectedStencilContext: StencilContext {

    private let fileHeader: String
    private let nodeName: String
    private let pluginName: String
    private let analyticsImports: [String]
    private let analyticsTestsImports: [String]
    private let builderImports: [String]
    private let builderTestsImports: [String]
    private let contextImports: [String]
    private let contextTestsImports: [String]
    private let flowImports: [String]
    private let flowTestsImports: [String]
    private let pluginImports: [String]
    private let pluginTestsImports: [String]
    private let stateImports: [String]
    private let dependencies: [[String: Any]]
    private let componentDependencies: String
    private let analyticsProperties: [[String: Any]]
    private let flowProperties: [[String: Any]]
    private let viewControllableFlowType: String
    private let viewControllableType: String
    private let viewControllableMockContents: String
    private let contextGenericTypes: [String]
    private let workerGenericTypes: [String]
    private let isPeripheryCommentEnabled: Bool
    private let isNimbleEnabled: Bool

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "node_name": nodeName,
            "plugin_name": pluginName,
            "owns_view": false,
            "analytics_imports": analyticsImports,
            "analytics_tests_imports": analyticsTestsImports,
            "builder_imports": builderImports,
            "builder_tests_imports": builderTestsImports,
            "context_imports": contextImports,
            "context_tests_imports": contextTestsImports,
            "flow_imports": flowImports,
            "flow_tests_imports": flowTestsImports,
            "plugin_imports": pluginImports,
            "plugin_tests_imports": pluginTestsImports,
            "state_imports": stateImports,
            "dependencies": dependencies,
            "component_dependencies": componentDependencies,
            "analytics_properties": analyticsProperties,
            "flow_properties": flowProperties,
            "view_controllable_flow_type": viewControllableFlowType,
            "view_controllable_type": viewControllableType,
            "view_controllable_mock_contents": viewControllableMockContents,
            "context_generic_types": contextGenericTypes,
            "worker_generic_types": workerGenericTypes,
            "is_periphery_comment_enabled": isPeripheryCommentEnabled,
            "is_nimble_enabled": isNimbleEnabled
        ]
    }

    // swiftlint:disable:next function_default_parameter_at_end
    public init(
        fileHeader: String,
        nodeName: String,
        pluginName: String,
        analyticsImports: Set<String>,
        analyticsTestsImports: Set<String>,
        builderImports: Set<String>,
        builderTestsImports: Set<String>,
        contextImports: Set<String>,
        contextTestsImports: Set<String>,
        flowImports: Set<String>,
        flowTestsImports: Set<String>,
        pluginImports: Set<String>,
        pluginTestsImports: Set<String>,
        stateImports: Set<String>,
        dependencies: [Config.Variable],
        componentDependencies: String = "",
        analyticsProperties: [Config.Variable],
        flowProperties: [Config.Variable],
        viewControllableFlowType: String,
        viewControllableType: String,
        viewControllableMockContents: String,
        contextGenericTypes: [String],
        workerGenericTypes: [String],
        isPeripheryCommentEnabled: Bool,
        isNimbleEnabled: Bool
    ) throws {
        self = try Self(
            strict: true,
            fileHeader: fileHeader,
            nodeName: nodeName,
            pluginName: pluginName,
            analyticsImports: analyticsImports,
            analyticsTestsImports: analyticsTestsImports,
            builderImports: builderImports,
            builderTestsImports: builderTestsImports,
            contextImports: contextImports,
            contextTestsImports: contextTestsImports,
            flowImports: flowImports,
            flowTestsImports: flowTestsImports,
            pluginImports: pluginImports,
            pluginTestsImports: pluginTestsImports,
            stateImports: stateImports,
            dependencies: dependencies,
            componentDependencies: componentDependencies,
            analyticsProperties: analyticsProperties,
            flowProperties: flowProperties,
            viewControllableFlowType: viewControllableFlowType,
            viewControllableType: viewControllableType,
            viewControllableMockContents: viewControllableMockContents,
            contextGenericTypes: contextGenericTypes,
            workerGenericTypes: workerGenericTypes,
            isPeripheryCommentEnabled: isPeripheryCommentEnabled,
            isNimbleEnabled: isNimbleEnabled
        )
    }

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
        pluginImports: Set<String>,
        pluginTestsImports: Set<String>,
        stateImports: Set<String>,
        dependencies: [Config.Variable],
        analyticsProperties: [Config.Variable],
        flowProperties: [Config.Variable],
        viewControllableFlowType: String,
        viewControllableType: String,
        viewControllableMockContents: String,
        contextGenericTypes: [String],
        workerGenericTypes: [String],
        isPeripheryCommentEnabled: Bool,
        isNimbleEnabled: Bool
    ) throws {
        guard preset.isViewInjected
        else { throw StencilContextError.invalidPreset(preset.nodeName) }
        self = try Self(
            strict: false,
            fileHeader: fileHeader,
            nodeName: preset.nodeName,
            pluginName: "",
            analyticsImports: analyticsImports,
            analyticsTestsImports: analyticsTestsImports,
            builderImports: builderImports,
            builderTestsImports: builderTestsImports,
            contextImports: contextImports,
            contextTestsImports: contextTestsImports,
            flowImports: flowImports,
            flowTestsImports: flowTestsImports,
            pluginImports: pluginImports,
            pluginTestsImports: pluginTestsImports,
            stateImports: stateImports,
            dependencies: dependencies,
            componentDependencies: preset.componentDependencies,
            analyticsProperties: analyticsProperties,
            flowProperties: flowProperties,
            viewControllableFlowType: viewControllableFlowType,
            viewControllableType: viewControllableType,
            viewControllableMockContents: viewControllableMockContents,
            contextGenericTypes: contextGenericTypes,
            workerGenericTypes: workerGenericTypes,
            isPeripheryCommentEnabled: isPeripheryCommentEnabled,
            isNimbleEnabled: isNimbleEnabled
        )
    }

    private init(
        strict: Bool,
        fileHeader: String,
        nodeName: String,
        pluginName: String,
        analyticsImports: Set<String>,
        analyticsTestsImports: Set<String>,
        builderImports: Set<String>,
        builderTestsImports: Set<String>,
        contextImports: Set<String>,
        contextTestsImports: Set<String>,
        flowImports: Set<String>,
        flowTestsImports: Set<String>,
        pluginImports: Set<String>,
        pluginTestsImports: Set<String>,
        stateImports: Set<String>,
        dependencies: [Config.Variable],
        componentDependencies: String,
        analyticsProperties: [Config.Variable],
        flowProperties: [Config.Variable],
        viewControllableFlowType: String,
        viewControllableType: String,
        viewControllableMockContents: String,
        contextGenericTypes: [String],
        workerGenericTypes: [String],
        isPeripheryCommentEnabled: Bool,
        isNimbleEnabled: Bool
    ) throws {
        guard !strict || !Preset.isPresetNodeName(nodeName)
        else { throw StencilContextError.reservedNodeName(nodeName) }
        self.fileHeader = fileHeader
        self.nodeName = nodeName
        self.pluginName = pluginName
        self.analyticsImports = analyticsImports.sortedImports()
        self.analyticsTestsImports = analyticsTestsImports.sortedImports()
        self.builderImports = builderImports.sortedImports()
        self.builderTestsImports = builderTestsImports.sortedImports()
        self.contextImports = contextImports.sortedImports()
        self.contextTestsImports = contextTestsImports.sortedImports()
        self.flowImports = flowImports.sortedImports()
        self.flowTestsImports = flowTestsImports.sortedImports()
        self.pluginImports = pluginImports.sortedImports()
        self.pluginTestsImports = pluginTestsImports.sortedImports()
        self.stateImports = stateImports.sortedImports()
        self.dependencies = dependencies.map(\.dictionary)
        self.componentDependencies = componentDependencies
        self.analyticsProperties = analyticsProperties.map(\.dictionary)
        self.flowProperties = flowProperties.map(\.dictionary)
        self.viewControllableFlowType = viewControllableFlowType
        self.viewControllableType = viewControllableType
        self.viewControllableMockContents = viewControllableMockContents
        self.contextGenericTypes = contextGenericTypes
        self.workerGenericTypes = workerGenericTypes
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
        self.isNimbleEnabled = isNimbleEnabled
    }
}
