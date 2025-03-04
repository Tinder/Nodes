//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

public struct PluginListStencilContext: StencilContext {

    private let fileHeader: String
    private let pluginListName: String
    private let pluginListImports: [String]
    private let pluginListInterfaceImports: [String]
    private let pluginListTestsImports: [String]
    private let viewControllableFlowType: String
    private let isPeripheryCommentEnabled: Bool
    private let isNimbleEnabled: Bool

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "plugin_list_name": pluginListName,
            "plugin_list_imports": pluginListImports,
            "plugin_list_interface_imports": pluginListInterfaceImports,
            "plugin_list_tests_imports": pluginListTestsImports,
            "view_controllable_flow_type": viewControllableFlowType,
            "is_periphery_comment_enabled": isPeripheryCommentEnabled,
            "is_nimble_enabled": isNimbleEnabled
        ]
    }

    public init(
        fileHeader: String,
        pluginListName: String,
        pluginListImports: Set<String>,
        pluginListInterfaceImports: Set<String>,
        pluginListTestsImports: Set<String>,
        viewControllableFlowType: String,
        isPeripheryCommentEnabled: Bool,
        isNimbleEnabled: Bool
    ) {
        self.fileHeader = fileHeader
        self.pluginListName = pluginListName
        self.pluginListImports = pluginListImports.sortedImports()
        self.pluginListInterfaceImports = pluginListInterfaceImports.sortedImports()
        self.pluginListTestsImports = pluginListTestsImports.sortedImports()
        self.viewControllableFlowType = viewControllableFlowType
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
        self.isNimbleEnabled = isNimbleEnabled
    }
}
