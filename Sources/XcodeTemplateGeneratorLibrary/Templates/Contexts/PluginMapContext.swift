//
//  PluginMapContext.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 5/4/21.
//

public struct PluginMapContext: Context {

    private let fileHeader: String
    private let pluginMapName: String
    private let pluginMapImports: [String]
    private let viewControllableFlowType: String

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "plugin_map_name": pluginMapName,
            "plugin_map_imports": pluginMapImports,
            "view_controllable_flow_type": viewControllableFlowType
        ]
    }

    public init(
        fileHeader: String,
        pluginMapName: String,
        pluginMapImports: Set<String>,
        viewControllableFlowType: String
    ) {
        self.fileHeader = fileHeader
        self.pluginMapName = pluginMapName
        self.pluginMapImports = pluginMapImports.sortedImports()
        self.viewControllableFlowType = viewControllableFlowType
    }
}
