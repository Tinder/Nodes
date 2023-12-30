//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

public struct NodeViewInjectedStencilContext: StencilContext {

    private let fileHeader: String
    private let nodeName: String
    private let analyticsImports: [String]
    private let builderImports: [String]
    private let contextImports: [String]
    private let flowImports: [String]
    private let stateImports: [String]
    private let analyticsTestsImports: [String]
    private let contextTestsImports: [String]
    private let flowTestsImports: [String]
    private let dependencies: [[String: Any]]
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
            "owns_view": false,
            "analytics_imports": analyticsImports,
            "builder_imports": builderImports,
            "context_imports": contextImports,
            "flow_imports": flowImports,
            "state_imports": stateImports,
            "analytics_tests_imports": analyticsTestsImports,
            "context_tests_imports": contextTestsImports,
            "flow_tests_imports": flowTestsImports,
            "dependencies": dependencies,
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

    public init(
        fileHeader: String,
        nodeName: String,
        analyticsImports: Set<String>,
        builderImports: Set<String>,
        contextImports: Set<String>,
        flowImports: Set<String>,
        stateImports: Set<String>,
        analyticsTestsImports: Set<String>,
        contextTestsImports: Set<String>,
        flowTestsImports: Set<String>,
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
        self = try Self(
            strict: true,
            fileHeader: fileHeader,
            nodeName: nodeName,
            analyticsImports: analyticsImports,
            builderImports: builderImports,
            contextImports: contextImports,
            flowImports: flowImports,
            stateImports: stateImports,
            analyticsTestsImports: analyticsTestsImports,
            contextTestsImports: contextTestsImports,
            flowTestsImports: flowTestsImports,
            dependencies: dependencies,
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
        preset: NodePreset,
        fileHeader: String,
        analyticsImports: Set<String>,
        builderImports: Set<String>,
        contextImports: Set<String>,
        flowImports: Set<String>,
        stateImports: Set<String>,
        analyticsTestsImports: Set<String>,
        contextTestsImports: Set<String>,
        flowTestsImports: Set<String>,
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
            analyticsImports: analyticsImports,
            builderImports: builderImports,
            contextImports: contextImports,
            flowImports: flowImports,
            stateImports: stateImports,
            analyticsTestsImports: analyticsTestsImports,
            contextTestsImports: contextTestsImports,
            flowTestsImports: flowTestsImports,
            dependencies: dependencies,
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
        analyticsImports: Set<String>,
        builderImports: Set<String>,
        contextImports: Set<String>,
        flowImports: Set<String>,
        stateImports: Set<String>,
        analyticsTestsImports: Set<String>,
        contextTestsImports: Set<String>,
        flowTestsImports: Set<String>,
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
        guard !strict || NodePreset(rawValue: nodeName) == nil
        else { throw StencilContextError.reservedNodeName(nodeName) }
        self.fileHeader = fileHeader
        self.nodeName = nodeName
        self.analyticsImports = analyticsImports.sortedImports()
        self.builderImports = builderImports.sortedImports()
        self.contextImports = contextImports.sortedImports()
        self.flowImports = flowImports.sortedImports()
        self.stateImports = stateImports.sortedImports()
        self.analyticsTestsImports = analyticsTestsImports.sortedImports()
        self.contextTestsImports = contextTestsImports.sortedImports()
        self.flowTestsImports = flowTestsImports.sortedImports()
        self.dependencies = dependencies.map(\.dictionary)
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
