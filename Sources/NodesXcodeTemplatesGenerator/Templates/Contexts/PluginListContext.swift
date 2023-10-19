//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

public struct PluginListContext: Context {

    private let fileHeader: String
    private let pluginListName: String
    private let pluginListImports: [String]
    private let viewControllableFlowType: String
    private let includePeripheryIgnores: Bool

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "plugin_list_name": pluginListName,
            "plugin_list_imports": pluginListImports,
            "view_controllable_flow_type": viewControllableFlowType,
            "include_periphery_ignores": includePeripheryIgnores
        ]
    }

    public init(
        fileHeader: String,
        pluginListName: String,
        pluginListImports: Set<String>,
        viewControllableFlowType: String,
        includePeripheryIgnores: Bool
    ) {
        self.fileHeader = fileHeader
        self.pluginListName = pluginListName
        self.pluginListImports = pluginListImports.sortedImports()
        self.viewControllableFlowType = viewControllableFlowType
        self.includePeripheryIgnores = includePeripheryIgnores
    }
}
