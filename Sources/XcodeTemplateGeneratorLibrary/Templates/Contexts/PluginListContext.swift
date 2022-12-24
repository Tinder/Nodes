//
//  PluginListContext.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 5/4/21.
//

public struct PluginListContext: Context {

    private let fileHeader: String
    private let pluginListName: String
    private let pluginListImports: [String]
    private let viewControllableFlowType: String
    private let pluginListItemName: String

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "plugin_list_name": pluginListName,
            "plugin_list_imports": pluginListImports,
            "view_controllable_flow_type": viewControllableFlowType,
            "plugin_list_item_name": pluginListItemName,
            "plugin_list_item_component_factory_name": pluginListItemName.firstLowercased
        ]
    }

    public init(
        fileHeader: String,
        pluginListName: String,
        pluginListImports: Set<String>,
        viewControllableFlowType: String,
        pluginListItemName: String
    ) {
        self.fileHeader = fileHeader
        self.pluginListName = pluginListName
        self.pluginListImports = pluginListImports.sortedImports()
        self.viewControllableFlowType = viewControllableFlowType
        self.pluginListItemName = pluginListItemName
    }
}

private extension StringProtocol {
    var firstLowercased: String { return prefix(1).lowercased() + dropFirst() }
}
