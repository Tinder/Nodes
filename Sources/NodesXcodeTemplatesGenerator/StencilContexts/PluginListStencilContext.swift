//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

public struct PluginListStencilContext: StencilContext {

    private let fileHeader: String
    private let pluginListName: String
    private let pluginListImports: [String]
    private let viewControllableFlowType: String
    private let isPeripheryCommentEnabled: Bool
    private let pluginListItemName: String

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "plugin_list_name": pluginListName,
            "plugin_list_imports": pluginListImports,
            "view_controllable_flow_type": viewControllableFlowType,
            "is_periphery_comment_enabled": isPeripheryCommentEnabled,
            "plugin_list_item_name": pluginListItemName,
            "plugin_list_item_component_factory_name": pluginListItemName.firstLowercased
        ]
    }

    public init(
        fileHeader: String,
        pluginListName: String,
        pluginListImports: Set<String>,
        viewControllableFlowType: String,
        isPeripheryCommentEnabled: Bool,
        pluginListItemName: String = ""
    ) {
        self.fileHeader = fileHeader
        self.pluginListName = pluginListName
        self.pluginListImports = pluginListImports.sortedImports()
        self.viewControllableFlowType = viewControllableFlowType
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
        self.pluginListItemName = pluginListItemName
    }
}

extension StringProtocol {
    fileprivate var firstLowercased: String { prefix(1).lowercased() + dropFirst() }
}
