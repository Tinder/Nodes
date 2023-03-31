//
//  PluginContext.swift
//  NodesXcodeTemplatesGeneratorLibrary
//
//  Created by Christopher Fuller on 5/4/21.
//

public struct PluginContext: Context {

    private let fileHeader: String
    private let pluginName: String
    private let returnType: String?
    private let pluginImports: [String]

    internal var dictionary: [String: Any] {
        guard let returnType = returnType else {
            return [
                "file_header": fileHeader,
                "plugin_name": pluginName,
                "plugin_imports": pluginImports
            ]
        }
        return [
            "file_header": fileHeader,
            "plugin_name": pluginName,
            "return_type": returnType,
            "plugin_imports": pluginImports
        ]
    }

    public init(
        fileHeader: String,
        pluginName: String,
        pluginImports: Set<String>
    ) {
        self.fileHeader = fileHeader
        self.pluginName = pluginName
        self.returnType = nil
        self.pluginImports = pluginImports.sortedImports()
    }

    public init(
        fileHeader: String,
        pluginName: String,
        returnType: String,
        pluginImports: Set<String>
    ) {
        self.fileHeader = fileHeader
        self.pluginName = pluginName
        self.returnType = returnType
        self.pluginImports = pluginImports.sortedImports()
    }
}
